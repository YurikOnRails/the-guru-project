#!/usr/bin/env bash
# exit on error
set -o errexit

# Ensure storage directory exists and is writable
mkdir -p storage
chmod -R 755 storage

# Install gems
bundle install

# Prepare assets
bundle exec rake assets:precompile
bundle exec rake assets:clean

# Create database files if they don't exist
[ -f storage/production.sqlite3 ] || touch storage/production.sqlite3
[ -f storage/production_cache.sqlite3 ] || touch storage/production_cache.sqlite3
[ -f storage/production_queue.sqlite3 ] || touch storage/production_queue.sqlite3
[ -f storage/production_cable.sqlite3 ] || touch storage/production_cable.sqlite3

# Make sure database files have correct permissions (only if needed)
chmod 644 storage/*.sqlite3

# Run migrations and seed data
RAILS_ENV=production DATABASE_URL=sqlite3:storage/production.sqlite3 bundle exec rake db:migrate
RAILS_ENV=production DATABASE_URL=sqlite3:storage/production.sqlite3 bundle exec rake db:seed

# Show available database files for debugging 2
echo "Available database files after build:"
ls -la storage/ 