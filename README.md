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

## Deployment

Deployment instructions will be here as soon as possible.

### Authors

* [Yaroslav Liakh](https://github.com/yashka713)

Prerequisites
-------------
Required software: 

* `ruby`
* `postgresDb`
* [hivemind](https://github.com/DarthSim/hivemind)

Install
-----------------
```
git clone git@github.com:yashka713/on_money_back.git
bundle install
bundle exec rake db:create
bundle exec rake db:migrate
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

Navigate to [http://localhost:3000](http://localhost:3000) or run `curl localhost:3000/status`.

Tests
-------------

Run:

```
rubocop
rspec
```
