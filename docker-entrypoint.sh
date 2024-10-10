#!/bin/sh
# https://stackoverflow.com/a/38732187/1935918
set -e
set -x

if [ -f /code/tmp/pids/server.pid ]; then
  rm /code/tmp/pids/server.pid
fi

gem update --system

if [ -f /code/Gemfile.lock ]; then
  gem install bundler -v $(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -1 | cut -d " " -f 4)
else
  gem install bundler
fi

bundle install
npm install
bundle exec rake db:create
bundle exec rake db:migrate

if [ "$RAILS_ENV" = "development" ]; then
  ./bin/dev
else
  exec bundle exec "$@"
fi
