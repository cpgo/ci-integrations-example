FROM ruby:2.7.0-alpine3.7

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true


ENV RUNTIME_PACKAGES libxml2 libxslt tzdata libstdc++ nodejs
ENV BUILD_PACKAGES ruby-dev build-base libxml2-dev libxslt-dev postgresql-dev
RUN apk add --update --no-cache $RUNTIME_PACKAGES $BUILD_PACKAGES


COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/

RUN bundle config build.nokogiri --use-system-libraries
RUN bundle config --global frozen 1
RUN bundle install --without development test

COPY . /usr/src/app
RUN bundle exec rake DATABASE_URL=$DATABASE_URL assets:precompile

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server"]
