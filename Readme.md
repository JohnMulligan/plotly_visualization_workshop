# Plotly Visualization Workshop

This repo contains two apps ready for deployment on Heroku in Plotly. Prerequisites:

1. Python
	1. Version 3.x: https://www.python.org/downloads/
	1. Python Virtual Environments: https://docs.python.org/3/library/venv.html
	1. Python Pip: https://pypi.org/project/pip/
1. Heroku
	1. Heroku Account: Get a heroku account: https://dashboard.heroku.com/
	1. Heroku CLI: https://devcenter.heroku.com/articles/heroku-cli
1. Docker. I use Docker Desktop: https://docs.docker.com/desktop/
1. Git. https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
1. An Airtable Account.
	1. The Python App uses a very specific Airtable: https://airtable.com/invite/l?inviteId=invjv5uAHuO6FiMYo&inviteToken=b74071af24bdf6104c8fe779e3fd4c0e734b15f9217b4ee0bf91477b438cc5f9
	1. You'll want to copy that base to your own account and create an API key: https://support.airtable.com/hc/en-us/articles/360056249614



## Python App: "python_citation_sankeys"

This app connects to a specific Airtable: 
(I will provide API keys in class)

* Downloads the two data tables (sources (nodes) and citations (edges))
* Parses the authors, privileging one author, whose citations we are tracking (Michel Foucault)
* Parses the citations between texts
* Bundles the cited texts by author
* Creates a nodes/edge graph according to the Plotly Sankey specifications

See https://plotly.com/python/sankey-diagram/

## R App: "R_covid_linegraphs"

This contains 3 apps that parse a large csv (~50MB) from the CDC: https://data.cdc.gov/NCHS/Weekly-counts-of-death-by-jurisdiction-and-cause-o/u6jv-9ijr/

* 3 sample apps
	* sample.r displays weekly mortality by for one cause, state, and year
	* sample_withloop.r -- by multiple years for one cause and state
	* sample_loop_plus_selector.r -- by multiple years with state, cause, & count type selectors
* 1 production-ready app: farrington_bystate_dash.R