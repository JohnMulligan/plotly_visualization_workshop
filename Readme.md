# Plotly Visualization Workshop

This repo contains one two apps, (nearly!) ready for deployment on Heroku in Plotly.

Prior to class, try to do the following. Show up early if you're having trouble!
1. Download this repo: `git clone https://github.com/JohnMulligan/plotly_visualization_workshop`
1. Install R
	1. R installation instructions: 
	1. Try to install these packages:
		1. install.packages('lifecycle')
		1. install.packages('remotes')
		1. install.packages('surveillance')
		1. install.packages('plyr')
		1. install.packages('dash')
		1. install.packages('tidyr')
		1. install.packages('readr')
		1. install.packages('plotly')
1. Install Python 3
	1. Install virtual environments: https://docs.python.org/3/library/venv.html
	1. Try to do the following (we'll try to catch you up in class if you can't)
		1. Start a virtual environment in the python app folder:
			1. `cd python_citation_sankeys`
			1. `python3 -m venv venv`
			1. `source venv/bin/activate`
			1. `pip3 install -r requirements.txt`
1. Get a heroku account: https://dashboard.heroku.com/

## Python App: "python_citation_sankeys"

This app connects to a specific Airtable.
(I will provide keys in class)

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