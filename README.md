# Knesset Data People

Aggregate data about members of Knesset and other people relating to Knesset data.

Uses the [datapackage pipelines framework](https://github.com/frictionlessdata/datapackage-pipelines)


## Usage

Install recent versions of Docker and Docker Compose

Start a local pipelines server

```
docker-compose up -d pipelines
```

Pipelines status dashboard is available at http://localhost:5000/

List the available pipelines:

```
docker-compose exec pipelines dpp
```

Run a pipeline:

```
docker-compose exec pipelines dpp run <PIPELINE_ID>
```


## Development

Install some system dependencies, the following should work on recent versions of Ubuntu / Debian

```
sudo apt-get install -y python3.6 python3-pip python3.6-dev libleveldb-dev libleveldb1v5
sudo pip3 install pipenv
```

Install the app depepdencies

```
pipenv install
```

Activate the virtualenv

```
pipenv shell
```

List the available pipelines

```
dpp
```

Run a pipeline

```
dpp run <PIPELINE_ID>
```


## Travis CI

Travis builds the data and uploads to GitHub `data` branch

To enable Travis updating GitHub, you need to have a [GitHub Machine User](https://developer.github.com/v3/guides/managing-deploy-keys/#machine-users)

give the user write permissions and set in Travis private var

```
travis env --private set GIT_REPO_TOKEN "***"
```
