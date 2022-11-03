#!/usr/bin/env bash
# exit on error
set -o errexit

bundle exec rake assets:clobber RAILS_ENV=production
bundle exec rake assets:precompile RAILS_ENV=production
bundle exec rake assets:clean RAILS_ENV=production
bundle exec ridgepole -E production -c config/database.yml -f db/Schemafile --apply
