FROM ruby:2.4

LABEL maintainer="Will Payne <will@paynelabs.io>"

RUN gem install bundler

WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install

WORKDIR /opt/sinatra-sidekiq-example

ADD . /opt/sinatra-sidekiq-example

EXPOSE 5000