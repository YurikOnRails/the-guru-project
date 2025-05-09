# syntax=docker/dockerfile:1

# This Dockerfile is designed for production, not development.
# Optimized for deployment on render.com

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.2.6
ARG NODE_VERSION=20
ARG YARN_VERSION=1.22.19

FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test" \
    RAILS_LOG_TO_STDOUT="1" \
    RAILS_SERVE_STATIC_FILES="true" \
    SECRET_KEY_BASE_DUMMY="1" \
    LANG=C.UTF-8

# Install base packages
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    curl \
    gnupg2 \
    libjemalloc2 \
    libvips \
    postgresql-client \
    libpq-dev \
    nodejs \
    npm \
    git \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    build-essential \
    git \
    pkg-config \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local without 'development test' && \
    bundle install --jobs=4 --retry=3 && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Создаем master.key из переменной окружения если она доступна
RUN if [ -n "$RAILS_MASTER_KEY" ]; then \
        echo "$RAILS_MASTER_KEY" > config/master.key; \
        chmod 600 config/master.key; \
    fi

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production using dummy key
RUN SECRET_KEY_BASE=dummy bundle exec rails assets:precompile

# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Ensure correct permissions for runtime
RUN mkdir -p /rails/tmp/pids && \
    mkdir -p /rails/log && \
    mkdir -p /rails/storage && \
    mkdir -p /rails/config && \
    chmod -R 777 /rails/tmp && \
    chmod -R 777 /rails/log && \
    chmod -R 777 /rails/storage && \
    chmod 775 /rails/config

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp config
USER 1000:1000

# Health check to ensure container is running properly
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 CMD curl -f http://localhost:${PORT:-3000}/ || exit 1

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start server with dynamic port
EXPOSE ${PORT:-3000}
CMD ./bin/thrust ./bin/rails server -p ${PORT:-3000} -b 0.0.0.0
