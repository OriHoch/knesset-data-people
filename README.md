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

List the available pipelines

```
dpp
```

Run a pipeline

```
dpp run <PIPELINE_ID>
```
