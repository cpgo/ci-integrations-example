FROM ruby:2.5

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qqy && apt-get -qqyy install \
    nodejs \
    yarn \
  && rm -rf /var/lib/apt/lists/*

RUN bundle config --global frozen 1
RUN bundle install --without development test

# RUN /bin/bash -c "curl -sL https://deb.nodesource.com/setup_9.x | /bin/bash -" && \
#     /bin/bash -c "curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -" && \
#     apt-get update && apt-get install -y nodejs build-essential yarn
# RUN apt-get remove cmdtest -y



COPY . /usr/src/app
RUN bundle exec rake DATABASE_URL=$DATABASE_URL assets:precompile

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server"]
