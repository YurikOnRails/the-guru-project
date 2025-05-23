#!/usr/bin/env bash
# exit on error
set -o errexit

# Print commands before executing them (for debugging)
set -o xtrace

# Ensure storage directory exists and is writable
mkdir -p storage
chmod -R 755 storage

# Install gems
bundle install

# Prepare assets
bundle install --without development test
bundle exec rake assets:precompile
bundle exec rake assets:clean

# Create database files if they don't exist
[ -f storage/production.sqlite3 ] || touch storage/production.sqlite3
[ -f storage/production_cache.sqlite3 ] || touch storage/production_cache.sqlite3
[ -f storage/production_queue.sqlite3 ] || touch storage/production_queue.sqlite3
[ -f storage/production_cable.sqlite3 ] || touch storage/production_cable.sqlite3

# Make sure database files have correct permissions (only if needed)
chmod 644 storage/*.sqlite3

# Reset and recreate database
echo "Resetting database..."
RAILS_ENV=production DATABASE_URL=sqlite3:storage/production.sqlite3 bundle exec rake db:drop db:create

# Run migrations
echo "Running database migrations..."
RAILS_ENV=production DATABASE_URL=sqlite3:storage/production.sqlite3 bundle exec rake db:migrate
RAILS_ENV=production DATABASE_URL=sqlite3:storage/production.sqlite3 bundle exec rake db:schema:load

# Run seeds only if needed (check if we need to seed first)
if [ -z "$(RAILS_ENV=production bundle exec rails runner 'exit User.count > 0')" ]; then
  echo "Seeding database..."
  RAILS_ENV=production DATABASE_URL=sqlite3:storage/production.sqlite3 bundle exec rake db:seed
else
  echo "Database already has users, skipping seed"
fi

# Show available database files for debugging
echo "Available database files after build:"
ls -la storage/

echo "Build script completed successfully!" 