# Gruby

Gruby aims to be a simple household app that helps you plan your meals, do your tasks and keep track of your finances

## Deployment (WIP)

gruby can easily be deployed via docker. It is recommended to use a proxy like nginx or apache.

1. Edit the config as needed, set up your database (gruby will be tested with sqlite3 and postgresql)
2. Setup secrets and master keys
2. Build docker image (`docker build -t gruby:latest .`)
3. Run the docker image

(It is not quite that easy, but you will figure it out)

## Development

The repository provides a dockerfile for a development environment.
Go ahead and build the docker image

```
docker build -t gruby-dev -f Dockerfile.dev
```

and start the container

```
docker run --rm --volume "$PWD:/gruby" gruby-dev rails db:migrate
docker run --rm -i -t -p "3000:3000" --volume "$PWD:/gruby" gruby-dev ./bin/dev
```

and off you go. Grab your favorite text editor, make some changes and browse to http://127.0.0.1:3000 to see the results. No frisky setup of dependencies needed (aside of docker)

# License

This code is provided as is, without warranty of any kind. Be aware of the license of dependencies.
