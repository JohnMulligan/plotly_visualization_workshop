# Dockerized Covid Dash in R

This repo contains 3 builds of a Plotly app in R for quantifying covid-related mortality.

It also contains Dockerfiles for building the environment for local and remote deployment.

## Docker

### Local Deployment

This is based on the remote Heroku deployment for consistency and predictability

1. You must have docker installed, of course! I use Docker Desktop: https://docs.docker.com/desktop/
1. The local deployment dockerfile is "Dockerfile-local". I'd recommend reading it before you deploy.
1. *BUILD* by specifying that file with -f, and I'd recommend tagging it as well, e.g.
	1. `docker build -f Dockerfile-local -t localcovidr`
	1. That will build an image tagged as localcovidrj using the instructions in Dockerfile-local
1. Building efficiently:
	1. The first build will take a while (10 minutes on my macbook). It's constructing a special R environment tuned for deployment on Heroku.
	1. However:
		1. *if all you're changing is the R app or lines in Dockerfile-local before line 15 ("from base as build")*
		1. then: subsequent builds will go very quickly (~30 seconds for me) because I've made that R environment into a base image.
	
1. *RUN* by specifying the host and port to bind the service to. I'd recommend naming the container as well, e.g.:
	1. `docker run -d -p 0.0.0.0:8050:8050 localcovidr`
	1. This will
		1. launch the image in background (-d flag)
		1. tag it as "localcovidr"
		1. which you can access in your browser at 0.0.0.0:8050
1. Now run docker ps
1. You will see a container with a random name running your image
1. *STOP* by running `docker stop RANDOM_CONTAINER_NAME`

As you can see on Dockerfile-local, this is launching farrington_bystate_dash.R. You can swap out any of the other scripts here, such as sample.r

### Remote Deployment

Once your local build is working well, you can easily deploy this to Heroku. Much of this is essentially copied from https://dashr.plotly.com/deployment

It depends on you having Heroku CLI installed and an account set up: https://devcenter.heroku.com/articles/git

`heroku create --stack container my-dash-app # change my-dash-app to a unique name
git add . # add all files to git
git commit -m 'Initial app boilerplate'
git push heroku master # deploy code to Heroku
heroku ps:scale web=1  # run the app with one Heroku 'dyno'`

You should be able to access your app at https://my-dash-app.herokuapp.com (changing my-dash-app to the name of your app).

To update and redeploy:

`git status # view the changes
git add .  # add all the changes
git commit -m 'a description of the changes'
git push heroku master`