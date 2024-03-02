# Gruby

Gruby aims to be a simple household app that helps you plan your meals, do your tasks and keep track of your finances


gruby can easily be deployed via docker. It is recommended to use a proxy like nginx or apache.

## Quick demo (If you want to deploy gruby follow the steps in the deployment section)

For a quick demo of gruby execute

```
docker run --rm \
  -e RAILS_MASTER_KEY=PjZf82D2u7dFgHzzx7xABBT1r9TCPSsD \
  -e SECRET_KEY_BASE=PjZf82D2u7dFgHzzx7xABBT1r9TCPSsD \
  -e GRUBY_DB_ADAPTER=sqlite3 \
  -p 3000:3000 \
  cacaocowdev/gruby \
  /bin/sh -c "/usr/src/app/bin/rails db:migrate db:seed; /usr/src/app/bin/rails server -b 0.0.0.0"
```

It will pull and start the gruby container. Navigate to http://localhost:3000/ and log in with the credentials `test@test` and `testtest`

## Deployment (WIP)

1. Copy the file **docker-compose-deployment.yml**
2. Replace the `RAILS_MASTER_KEY` and `SECRET_KEY_BASE` environment variables with your own randomly generated secrets
3. Start docker images with `docker compose -f docker-compose-deployment.yml up -d`
4. Setup database with `docker compose -f docker-compose-deployment.yml exec gruby /usr/src/app/bin/rails db:migrate`
5. Create a login `docker compose -f docker-compose-deployment.yml exec gruby /usr/src/app/bin/rails console`
  1. `User.new({:email => '<email>', :password => '<password>'}).save` (has to be a valid email and password has to be at least 8 characters)
  2. exit with `quit`
6. Navigate to `localhost:3000` and login with the credentials

### Docker environment variables

| Name | Description | Default |
| --- | --- | --- |
| RAILS_MASTER_KEY | Secret key to encrypt various rails stuff | `None` |
| GRUBY_DB_ADAPTER | Sets the database adapter, supported values are `postgresql` and `sqlite3` | `postgresql` |
| GRUBY_DB_NAME | For `postgresql` this is the name of the database on the database server, for `sqlite3` path and name to the database file | `gruby` |
| GRUBY_DB_HOST | Host of the database server, only required for `postgresql` | `db` |
| GRUBY_DB_PORT | Port of the database server, only required for `postgresql` | `5432` |
| GRUBY_DB_USERNAME | Username for the database server, only required for `postgresql` | `gruby` |
| GRUBY_DB_PASSWORD | Password for the database server, only required for `postgresql` | `gruby` |
| GRUBY_DB_POOL_SIZE | Number of connecections for the database server, only required for `postgresql` | `5` |
| GRUBY_STORAGE | Storage location for uploaded data | `/usr/src/app/storage` |

## Development

The repository provides a dockerfile for a development environment.
Go ahead and build the docker image

```
docker build -t gruby-dev -f Dockerfile.dev .
```

and start the container

```
docker run --rm --volume "$PWD:/gruby" gruby-dev rails db:migrate
docker run --rm -i -t -p "3000:3000" --volume "$PWD:/gruby" gruby-dev ./bin/dev
```

and off you go. Grab your favorite text editor, make some changes and browse to http://127.0.0.1:3000 to see the results. No frisky setup of dependencies needed (aside of docker)

# License

This code is provided as is, without warranty of any kind. Be aware of the license of dependencies.
