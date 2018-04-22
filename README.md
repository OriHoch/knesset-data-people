# Knesset Data People

[![Build Status](https://travis-ci.org/OriHoch/knesset-data-people.svg?branch=data)](https://travis-ci.org/OriHoch/knesset-data-people)

Aggregate data about members of Knesset and other people relating to Knesset data.

Part of [Knesset Data Pipelines](https://github.com/hasadna/knesset-data-pipelines)

Uses the [datapackage pipelines framework](https://github.com/frictionlessdata/datapackage-pipelines)


## Installation

following should work on recent versions of Ubuntu / Debian

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

Install some additional dependencies

```
pip install --upgrade https://github.com/OriHoch/datapackage-pipelines/archive/cli-support-list-of-pipeline-ids.zip
pip install --upgrade https://github.com/OriHoch/knesset-data-pipelines/archive/add-missing-tables-from-knesset.zip
```

List the available pipelines

```
dpp
```

Run a pipeline

```
dpp run <PIPELINE_ID>
```


## Running using docker

If you have access to the required secrets and google cloud account, you can use the following command to run with all required dependencies:

```
docker run -d --rm --name postgresql -p 5432:5432 -e POSTGRES_PASSWORD=123456 postgres
docker build -t knesset-data-people .
docker run -it -e DUMP_TO_STORAGE=1 \
               -e DUMP_TO_SQL=1 \
               -e DPP_DB_ENGINE=postgresql://postgres:123456@postgresql:5432/postgres \
               -v /path/to/google/secret/key:/secret_service_key \
               --link postgresql \
               --entrypoint bash \
               knesset-data-people
```
