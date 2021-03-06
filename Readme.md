# Plotly Visualization Workshop

This repo contains two apps ready for deployment in Docker, locally and to Heroku.

## Requirements

1. Docker. https://docs.docker.com/desktop/
1. Git. https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
1. An Airtable Account. https://airtable.com/
1. Heroku. https://devcenter.heroku.com/articles/heroku-cli

## Python App: "python_citation_sankeys"

* This app connects to a specific Airtable
* Downloads the two data tables
* Parses the tables
* Creates a nodes/edge Sankey graph in Plotly

See https://plotly.com/python/sankey-diagram/

## R App: "R_covid_linegraphs"

This contains 3 apps that parse a large csv (~50MB) from the CDC: https://data.cdc.gov/NCHS/Weekly-counts-of-death-by-jurisdiction-and-cause-o/u6jv-9ijr/

* 3 sample apps
	* sample.r displays weekly mortality by for one cause, state, and year
	* sample_withloop.r -- by multiple years for one cause and state
	* sample_loop_plus_selector.r -- by multiple years with state, cause, & count type selectors
* 1 better-developed app with lots of callbacks: farrington_bystate_dash.R