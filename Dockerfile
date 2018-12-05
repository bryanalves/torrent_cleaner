FROM ruby:2.5.1

MAINTAINER Bryan Alves <bryanalves@gmail.com>

RUN mkdir /usr/src/app
WORKDIR /usr/src/app

COPY * /usr/src/app/
RUN bundle install

ENTRYPOINT ["ruby", "cli.rb"]
