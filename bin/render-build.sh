#!/usr/bin/env bash
# exit on error
set -o errexit

echo "Building Rails application..."

# Установка зависимостей
bundle install --without development test

# Компиляция ассетов
echo "Precompiling assets..."
bundle exec rails assets:precompile

# Миграция базы данных
echo "Preparing database..."
bundle exec rails db:prepare

echo "Build completed successfully!" 