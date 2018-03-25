FROM ruby:2.5.0
# prepare environment
RUN apt-get update -qq
RUN apt-get install -y -qq build-essential
RUN apt-get install -y -qq nodejs
RUN apt-get install -y -qq libpq-dev

RUN mkdir -p /railsapi

WORKDIR /railsapi

ADD Gemfile /railsapi/Gemfile
ADD Gemfile.lock /railsapi/Gemfile.lock
RUN bundle update
RUN bundle install
ADD . /railsapi
