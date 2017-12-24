# Knesset Data People

Aggregate data about members of Knesset and other people relating to Knesset data.

Uses the [datapackage pipelines framework](https://github.com/frictionlessdata/datapackage-pipelines)


## Usage

Start a local pipelines server

```
docker-compose up -d pipelines
```

check the available pipelines at http://localhost:5000/ or using the CLI:

```
docker-compose exec pipelines dpp
```

Run a pipeline

```
docker-compose exec pipelines dpp run <PIPELINE_ID>
```

Copy data files from the pipelines server to be available locally

```
docker cp knessetdatapeople_pipelines_1:/pipelines/data/members ./data/members
docker cp knessetdatapeople_pipelines_1:/pipelines/data/committees ./data/committees
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
