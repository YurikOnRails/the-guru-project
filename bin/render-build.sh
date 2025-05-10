#!/usr/bin/env bash
# exit on error
set -o errexit

# Print текущей среды и переменных
echo "RAILS_ENV: $RAILS_ENV"
echo "DATABASE_URL is set: $(if [ -n "$DATABASE_URL" ]; then echo "YES"; else echo "NO"; fi)"

# Install gems
bundle install

# Prepare assets
bundle exec rake assets:precompile
bundle exec rake assets:clean

# Проверка подключения к БД перед миграцией
echo "Проверка соединения с базой данных..."
bundle exec rails runner "puts \"БД доступна: \#{ActiveRecord::Base.connection.active?}\""

# Run migrations and seed data
echo "Запуск миграций..."
bundle exec rake db:migrate
echo "Миграции выполнены успешно!"

echo "Заполнение начальными данными..."
bundle exec rake db:seed
echo "База данных успешно настроена!" 