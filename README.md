# On Money(Back - end) [![Build Status](https://travis-ci.org/yashka713/on_money_back.svg?branch=master)](https://travis-ci.org/yashka713/on_money_back)

### Technical task [here](https://gist.github.com/yashka713/d4dc2210b04a45ffc0850de14ff1b4ff).

### Appointment

API for application which helps to follow of your money using simple friendly interface.

### Features

A description of the features will be added during the development process.

### Built With

* The Ruby language - version 2.5.0
* Ruby on Rails - version 5.1.5
* Postgres
* Hivemind (for launching)
* Docker
* Elasticsearch + Kibana

## Deployment

For deploying(*Heroku*):

1. Install [Heroku-cli](https://devcenter.heroku.com/articles/heroku-cli) localy

2. Configure it with `heroku git:remote -a {your_awesome_application_name}`

3. `git push heroku master`

### Authors

* [Yaroslav Liakh](https://github.com/yashka713)

Prerequisites
-------------
Required software: 

* `ruby`
* `postgresDb`
* [hivemind](https://github.com/DarthSim/hivemind)
* `Docker`
* `Elasticsearch` + `Kibana`

Install
-----------------
```
git clone git@github.com:yashka713/on_money_back.git
cp .env.example .env
bundle install
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake elasticsearch:reindex environment
```

Launch
------------

If you are using `hivemind` for launching back-end and front-end for development, please, configure `Procfile`
and start:
```
hivemind
```

or

```
rails s
```

or

```
docker-compose up --build
```

Navigate to [http://localhost:3000](http://localhost:3000) or run `curl localhost:3000/status`.

Docs
-------------

`Swagger` docs available [here](http://localhost:3000/api/v1/docs)

Tests
-------------

Run:

```
rubocop --config .rubocop.yml app/ spec/ db/migrate
rspec
```
