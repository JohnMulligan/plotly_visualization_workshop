*NOTE!* This won't run without API access to the table.
1. Get a copy of the base from https://airtable.com/invite/l?inviteId=invcSCxZRdNJErGrK&inviteToken=b74b70e33e12b862900721468ac80bb1eb863b2da5e29c3998ff728adc7c86d5
1. Get an airtable API key and base ID: https://airtable.com/account
1. Fill in the details in the file airtablekeys.json
1. You can see API examples/documentation that you can nearly copy and paste in this interface: https://airtable.com/api

# Dash Sankey from Airtable

This repo contains a Python app that:
1. Pulls entries from the specific airtable linked above
1. Rolls them up into cited authors & their works
1. Renders these as a Sankey diagram in Dash

*Instructions on installing this application locally and on heroku, dockerized or with virtualenvironments, follow* 

# With Docker

## Locally (requires Docker)

1. `docker build .`
1. Get built docker image id with `docker images`
1. Launch container with `docker run -p 0.0.0.0:5000:5000 IMAGE_ID`
1. Get docker container with `docker ps`
1. Stop container with `docker stop CONTAINER_ID`
1. Rebuild with `docker build .`
1. Clean up with:
	1. `docker images` to get image ID's
	1. `docker image rm -f IMAGE_ID`

## Remotely (Requires Heroku CLI)

Template for Dockerized Python Dash application deployed to Heroku: https://dash.plotly.com/deployment

Git instructions at https://devcenter.heroku.com/articles/git

1. `heroku container:login`
1. `heroku create UNIQUEAPPNAME`
1. `heroku container:push web --app UNIQUEAPPNAME`
1. `container:release`

---------------

# Without Docker

## Locally (requires virtual environment module on python)

1. Set up & initialize virtual environment:
	1. `python3 -m venv venv`
	1. `source venv/bin/activate`
1. Install the requirements into the virtual environment: `pip3 install -r requirements.txt`
1. GET YOUR AIRTABLE API KEYS!! SEE THE TOP OF THIS DOC.
1. Run the app: `python3 app.py`

## Deploying remotely (requires Heroku CLI)

We use the one-line Procfile included here and simply push to heroku

*NOTE. MOVE THIS DIRECTORY OUT OF THE PARENT WORKSHOP DIRECTORY OR THIS WILL GOOF UP THE BELOW GIT COMMANDS*

	git init
	heroku create APP_NAME_HERE
	git add .
	git commit -m "init"
	git push heroku master
	heroku ps:scale web=1
