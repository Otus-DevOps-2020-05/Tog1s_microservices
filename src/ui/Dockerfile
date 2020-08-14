FROM ruby:2.6-alpine

ENV APP_HOME=/app

RUN mkdir $APP_HOME

WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/

RUN apk add --update ruby-dev build-base \
    && gem install bundler \
    && bundle install \
    && apk del ruby-dev build-base

ADD . $APP_HOME

CMD ["puma"]
