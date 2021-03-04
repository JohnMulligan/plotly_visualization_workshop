*NOTE!* This won't run without API access to the table.
1. Get an airtable API key: https://support.airtable.com/hc/en-us/articles/360056249614
1. Get a copy of the base from https://airtable.com/invite/l?inviteId=invjv5uAHuO6FiMYo&inviteToken=b74071af24bdf6104c8fe779e3fd4c0e734b15f9217b4ee0bf91477b438cc5f9
1. Fill in the details in the file airtablekeys.json


# Dash Sankey from Airtable

This repo contains a Python app that:
1. Pulls entries from a specific airtable: https://airtable.com/tblv95c9K2woWnWDF/viwJu67h36bsF6LtT?blocks=hide
1. Rolls them up into cited authors & their works
1. Renders these as a Sankey diagram in Dash

*Instructions on installing this application locally and on heroku, dockerized or with virtualenvironments, follow*

# Without Docker

## Locally (requires virtual environment module on python)

1. Set up & initialize virtual environment:
	1. `python3 -m venv venv`
	1. `source venv/bin/activate`
1. Install the requirements into the virtual environment: `pip3 install -r requirements.txt`
1. Run the app: `python3 app.py`

## Deploying remotely (requires Heroku CLI)

We use the one-line Procfile included here and simply push to heroku

	`
	git init
	heroku create APP_NAME_HERE
	git add .
	git commit -m "init"
	git push heroku master
	heroku ps:scale web=1
	`

# With Docker

## Locally (requires Docker Desktop)

1. `docker build .`
1. Get built docker image id with `docker images`
1. Launch container with `docker run -p 0.0.0.0:5000:5000 IMAGE_ID`
1. Get docker container with docker ps
1. Stop container with `docker stop CONTAINER_ID`

## Remotely (Requires Heroku CLI)

1. `heroku container:login`
1. `heroku create UNIQUEAPPNAME`
1. `heroku container:push web --app UNIQUEAPPNAME`
1. `container:release`