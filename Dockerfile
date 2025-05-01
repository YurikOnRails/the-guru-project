# syntax=docker/dockerfile:1
# check=error=true

ARG RUBY_VERSION=3.2.6
FROM ruby:$RUBY_VERSION-slim AS base

# Указываем рабочую директорию
WORKDIR /rails

# Базовые пакеты для рантайма
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libjemalloc2 \
    libvips \
    sqlite3 \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

# ENV-переменные для продакшн
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# -------- BUILD STAGE --------
FROM base AS build

# Установка зависимостей для сборки нативных гемов
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    pkg-config \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Копируем Gemfile и устанавливаем гемы
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Копируем исходный код
COPY . .

# Предкомпиляция bootsnap и ассетов
RUN bundle
