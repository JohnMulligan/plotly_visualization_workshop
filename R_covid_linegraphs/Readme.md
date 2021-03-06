# Dockerized Covid Dash in R

This repo contains 3 builds of a Plotly app in R for quantifying covid-related mortality.

It also contains Dockerfiles for building the environment for local and remote deployment.

## Docker

### Local Deployment

This is based on the remote Heroku deployment for consistency and predictability

USE 2 TERMINAL WINDOWS:

#### *BUILD* by specifying the local build file: `docker build -f Dockerfile-local .`

#### *RUN* by specifying the host and port to bind the service to.
	1. `docker run -p 0.0.0.0:8050:8050`
	1. access in your browser at 0.0.0.0:8050
	1. Now run docker ps
	1. You will see a container with a random name running your image

#### *STOP* by:
	1. open a second terminal window
	1. type `docker ps` and see your running container ID's
	1. stop with `docker stop CONTAINER_ID`

#### *REBUILD* by:
	1. Changing some of your code
	1. Running the build command again: `docker build -f Dockerfile-local .`
	1. Rebuilds are fast, but they take up a lot of space:

#### *CLEAN UP* every once in a while with:
	1. `docker images` to see your stopped image ID's
	1. `docker image rm -f IMAGE_ID`

Note: deleting *all* of your stopped containers for this app will make your next rebuild slow.


### Remote Deployment

Once your local build is working well, you can easily deploy this to Heroku. Much of this is essentially copied from https://dashr.plotly.com/deployment

It depends on you having Heroku CLI installed and an account set up: https://devcenter.heroku.com/articles/git

	git init
	heroku create --stack container my-dash-app # change my-dash-app to a unique name
	git add . # add all files to git
	git commit -m 'Initial app boilerplate'
	git push heroku master # deploy code to Heroku
	heroku ps:scale web=1  # run the app with one Heroku 'dyno'

You should be able to access your app at https://my-dash-app.herokuapp.com (changing my-dash-app to the name of your app).

To update and redeploy:

	git status # view the changes
	git add .  # add all the changes
	git commit -m 'a description of the changes'
	git push heroku master
