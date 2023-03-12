FROM ruby:3.1.2-alpine as builder

WORKDIR /usr/src/app

RUN apk add build-base \
      nodejs-current \
      yarn \
      tzdata \
      postgresql-client \
      postgresql-dev \
    && mkdir -p /usr/src/app \
    && chown 999:999 /usr/src/app \
    && gem install bundler --version 2.3.19

USER 999:999

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true
ENV NODE_ENV production

COPY --chown=999:999 ./Gemfile /usr/src/app
COPY --chown=999:999 ./Gemfile.lock /usr/src/app
RUN bundle config --local frozen 1 \
    && bundle config set --local without development test \
    && bundle config set --local deployment true \
    && bundle install

COPY --chown=999:999 ./package.json /usr/src/app

RUN yarn install --pure-lockfile

COPY --chown=999:999 . /usr/src/app/
RUN rm config/credentials.yml.enc && \
    EDITOR="mate" bin/rails credentials:edit && \
    bundle exec rake assets:precompile

FROM ruby:3.1.2-alpine
COPY --from=builder --chown=999:999 /usr/src/app /usr/src/app

RUN apk add tzdata postgresql-client

WORKDIR /usr/src/app

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true
ENV NODE_ENV production

RUN bundle config --local frozen 1 \
    && bundle config set --local without development test \
    && bundle config set --local deployment true \

EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
