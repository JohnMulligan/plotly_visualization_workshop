import json
import requests
from optparse import OptionParser, Option, OptionValueError
import time
import re
import os
import sys
from operator import itemgetter
try:
	threshold=sys.argv[1]
except:
	pass

#Airtable authentication class taken from https://airtable-python-wrapper.readthedocs.io/en/master/authentication.html
class AirtableAuth(requests.auth.AuthBase):
    def __init__(self, api_key=None):
        try:
            self.api_key = api_key or os.environ["AIRTABLE_API_KEY"]
        except KeyError:
            raise KeyError(
                "Api Key not found. Pass api_key as a kwarg \
                            or set an env var AIRTABLE_API_KEY with your key")
    def __call__(self, request):
        auth_token = {"Authorization": "Bearer {}".format(self.api_key)}
        request.headers.update(auth_token)
        return request

def fetch_table_records(base_id,table,auth):
	
	records={}
	offset=''
	while True:
	
		url = 'https://api.airtable.com/v0/%s/%s' %(base_id,table)
		print(url)
		params={'offset':offset}
	
		response = requests.get(url,auth=auth,params=params)
		print(response)
		results = json.loads(response.text)
	
		new_records=results['records']
		
		for rec in new_records:
			records[rec['id']]=rec['fields']
	
		print(len(records))
	
		try:
			offset=results['offset']
		except:
			break

	return records

def main(threshold):
	threshold=int(threshold)
	d = open('airtablekeys.json','r')
	t = d.read()
	d.close()
	j = json.loads(t)
	auth = AirtableAuth(j['api_key'])
	base_id=j['base_id']
	text=fetch_table_records(base_id,'Texts',auth)
	texts={}
	for t in text:
		try:
			if "Reference" in text[t] and len(text[t]["Reference"])>=threshold:
				texts[t]=text[t]
			elif len(text[t]["Referenced"])>=threshold:
				texts[t]=text[t]
		except:
			pass
	links=fetch_table_records(base_id,'References',auth)
	edges={}
	#bundle the individual links by cited text
	for link in links:
		if 'Citing Text' in links[link] and 'Cited Text' in links[link]:
			source_id=links[link]['Citing Text'][0]
			target_id=links[link]['Cited Text'][0]
			if source_id in texts and target_id in texts:
				if source_id not in edges:
					edges[source_id]={target_id:1}
				else:
					if target_id not in edges[source_id]:
						edges[source_id][target_id]=1
					else:				
						edges[source_id][target_id]+=1
	

	#now intermediate between the citing texts (Foucault) and the cited texts with author names
	edges2={source_id:{} for source_id in edges}
	for source_id in edges:
		for target_id in edges[source_id]:
			source_node =texts[source_id]
			target_node =texts[target_id]
			
			target_author=target_node['Author']
			value=edges[source_id][target_id]
			if target_author not in edges2[source_id]:
				edges2[source_id][target_author]=value
			else:
				edges2[source_id][target_author]+=value
			if target_author not in edges2:
				edges2[target_author]={target_id:value}
			elif target_id not in edges2[target_author]:
				edges2[target_author][target_id]=value
			else:
				edges2[target_author][target_id]+=value
			
	#roll 'em out
	node_labels=[]
	for text in texts:
		print(texts[text]['Author'])
	foucault_nodes=[(i,texts[i]['Year']) for i in texts if texts[i]['Author']=='Michel Foucault']
	foucault_nodes.sort(key=lambda tup: tup[1])
	print(foucault_nodes)
	book_nodes=[(i,texts[i]['Author']) for i in texts if texts[i]['Author']!='Michel Foucault']
	book_nodes.sort(key=lambda tup: tup[1])
	print(book_nodes)
	authors = list(set([i[1] for i in book_nodes]))
	authors.sort()
	node_labels=[texts[i[0]]['Short Name'] for i in foucault_nodes] + authors + [texts[i[0]]['Short Name'] for i in book_nodes]
	print(node_labels)
	link_sources=[]
	link_targets=[]
	link_values=[]
	for source in edges2:
		if source in texts:
			source_label=texts[source]['Short Name']
		else:
			source_label=source
		#if source_label not in node_labels:node_labels.append(source_label)
		for target in edges2[source]:
			if target in texts:
				target_label=texts[target]['Short Name']
			else:
				target_label=target
			if target_label not in node_labels:
				node_labels.append(target_label)
			link_value=edges2[source][target]
			source_idx=node_labels.index(source_label)
			target_idx=node_labels.index(target_label)
			link_sources.append(source_idx)
			link_targets.append(target_idx)
			link_values.append(link_value)
	network={"node_labels":node_labels, "link_sources":link_sources,"link_targets":link_targets,"link_values":link_values}

	return network


if __name__ == "__main__":
	main(threshold)
