# Устранение проблем при деплое Rails-приложения с Docker

Этот документ содержит список распространенных проблем и ошибок, которые могут возникать при деплое Rails-приложения в Docker контейнере, особенно при использовании сервиса render.com.

## Содержание

- [Проблемы с секретами и переменными окружения](#проблемы-с-секретами-и-переменными-окружения)
- [Проблемы с базой данных PostgreSQL](#проблемы-с-базой-данных-postgresql)
- [Проблемы с Dockerfile](#проблемы-с-dockerfile)
- [Проблемы с ресурсами](#проблемы-с-ресурсами)
- [Проблемы с конфигурацией Render.com](#проблемы-с-конфигурацией-rendercom)
- [Проблемы с Asset Pipeline и Webpacker](#проблемы-с-asset-pipeline-и-webpacker)
- [Проблемы с портами и сетью](#проблемы-с-портами-и-сетью)
- [Чеклист для успешного деплоя](#чеклист-для-успешного-деплоя)

## Проблемы с секретами и переменными окружения

- [ ] **Отсутствие RAILS_MASTER_KEY**: Убедитесь, что переменная окружения `RAILS_MASTER_KEY` добавлена в настройки сервиса на render.com.
  ```
  # Проверка локально
  cat config/master.key
  
  # Скопируйте это значение в переменные окружения на render.com
  ```

- [ ] **Отсутствие файла credentials.yml.enc**: Если файл не существует, создайте его:
  ```bash
  # Создание нового файла credentials
  EDITOR="vim" bin/rails credentials:edit
  ```

- [ ] **Неправильное расположение master.key**: В Dockerfile проверьте логику копирования/создания master.key:
  ```dockerfile
  # Пример правильной обработки
  RUN if [ -n "$RAILS_MASTER_KEY" ]; then \
      echo "$RAILS_MASTER_KEY" > config/master.key; \
      chmod 600 config/master.key; \
  fi
  ```

- [ ] **Потерянные или некорректные переменные окружения**: Проверьте все переменные окружения, необходимые для приложения:
  - DATABASE_URL
  - RAILS_ENV
  - RAILS_SERVE_STATIC_FILES
  - SECRET_KEY_BASE
  - Любые API ключи или токены, используемые в приложении

## Проблемы с базой данных PostgreSQL

- [ ] **Некорректный DATABASE_URL**: Проверьте формат и значение URL подключения к базе данных:
  ```
  postgresql://username:password@hostname:port/database_name
  ```

- [ ] **Отсутствие миграций**: Убедитесь, что все миграции выполняются во время деплоя:
  ```yaml
  # Пример для render.yaml
  buildCommand: bundle exec rails db:migrate
  ```

- [ ] **Неуказанная версия PostgreSQL**: Укажите конкретную версию pg в Gemfile:
  ```ruby
  gem "pg", "~> 1.5.3"
  ```

- [ ] **Проблемы с пользователем базы данных**: Убедитесь, что пользователь имеет необходимые права:
  ```sql
  GRANT ALL PRIVILEGES ON DATABASE your_database TO your_user;
  ```

- [ ] **Конфликт портов PostgreSQL**: render.com использует свои собственные инстансы PostgreSQL, убедитесь что вы используете предоставленные URL, а не хардкоженные параметры.

## Проблемы с Dockerfile

- [ ] **Устаревшие версии Ruby/Node.js**: Проверьте, что используются поддерживаемые версии:
  ```dockerfile
  ARG RUBY_VERSION=3.2.6
  ARG NODE_VERSION=20
  ```

- [ ] **Отсутствующие системные зависимости**: Убедитесь, что все необходимые пакеты установлены:
  ```dockerfile
  RUN apt-get update -qq && \
      DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
      curl \
      libpq-dev \
      nodejs \
      # ... другие необходимые пакеты
  ```

- [ ] **Проблемы с precompile assets**: Проверьте процесс компиляции ассетов:
  ```dockerfile
  # Пример для Rails с учетом RAILS_MASTER_KEY
  RUN if [ -f config/master.key ] || [ -n "$RAILS_MASTER_KEY" ]; then \
      SECRET_KEY_BASE=$(bin/rails runner "puts Rails.application.credentials.secret_key_base") bundle exec rails assets:precompile; \
  else \
      SECRET_KEY_BASE=dummy bundle exec rails assets:precompile; \
  fi
  ```

- [ ] **Некорректные разрешения на файлы/папки**: Убедитесь, что директории имеют правильные разрешения:
  ```dockerfile
  RUN mkdir -p /rails/tmp/pids && \
      mkdir -p /rails/log && \
      chmod -R 777 /rails/tmp && \
      chmod -R 777 /rails/log
  ```

- [ ] **Проблемы с пользователем в контейнере**: Не запускайте приложение от root:
  ```dockerfile
  RUN groupadd --system --gid 1000 rails && \
      useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
      chown -R rails:rails db log storage tmp
  USER 1000:1000
  ```

## Проблемы с ресурсами

- [ ] **Недостаточно памяти**: render.com имеет лимиты памяти в зависимости от плана:
  - Бесплатный план: 512 MB RAM
  - Starter: 1 GB RAM
  - Убедитесь, что ваше приложение не превышает эти лимиты, особенно при компиляции ассетов или загрузке больших данных.

- [ ] **Недостаточно CPU**: Монитор ЦП во время сборки и запуска приложения. Рассмотрите возможность перехода на более высокий план, если наблюдаются постоянные проблемы.

- [ ] **Тайм-ауты при сборке**: render.com имеет ограничения на время сборки (обычно 15-30 минут). Оптимизируйте процесс сборки.

- [ ] **Ограничения дискового пространства**: Удалите ненужные файлы перед или во время сборки, минимизируйте размер образа.

## Проблемы с конфигурацией Render.com

- [ ] **Отсутствие render.yaml**: Создайте конфигурационный файл для автоматизации деплоя:
  ```yaml
  services:
    - type: web
      name: your-app-name
      env: ruby
      buildCommand: ./bin/render-build.sh
      startCommand: bundle exec rails server
      envVars:
        - key: RAILS_MASTER_KEY
          sync: false
        - key: DATABASE_URL
          fromDatabase:
            name: your-database
            property: connectionString
  
    - type: postgresql
      name: your-database
      ipAllowList: []
      plan: free
  ```

- [ ] **Настройка buildCommand**: Создайте скрипт `bin/render-build.sh`:
  ```bash
  #!/usr/bin/env bash
  set -o errexit
  
  bundle install
  bundle exec rails assets:precompile
  bundle exec rails db:migrate
  ```

- [ ] **Конфликты с кастомными web-серверами**: Если вы используете thruster вместо стандартного Puma, настройте startCommand соответствующим образом:
  ```yaml
  startCommand: ./bin/thrust bundle exec rails server -p $PORT -b 0.0.0.0
  ```

- [ ] **Неправильное указание порта**: render.com предоставляет порт через переменную окружения PORT. Убедитесь, что ваше приложение использует эту переменную:
  ```ruby
  # config/puma.rb
  port ENV.fetch("PORT") { 3000 }
  ```

## Проблемы с Asset Pipeline и Webpacker

- [ ] **Ошибки при компиляции JavaScript**: Проверьте совместимость версий Node.js и Yarn:
  ```dockerfile
  ARG NODE_VERSION=20
  ARG YARN_VERSION=1.22.19
  ```

- [ ] **Отсутствующие зависимости JavaScript**: Убедитесь, что все пакеты устанавливаются:
  ```bash
  yarn install --check-files
  ```

- [ ] **Проблемы с CSS/SCSS**: Проверьте совместимость sassc-rails с вашей версией Ruby.

- [ ] **Проблемы с Hotwire (Turbo/Stimulus)**: Убедитесь, что importmap-rails настроен правильно.

## Проблемы с портами и сетью

- [ ] **Несоответствие портов**: Убедитесь, что приложение слушает порт, предоставленный render.com:
  ```ruby
  # config/puma.rb
  port ENV.fetch("PORT") { 3000 }
  ```

- [ ] **Неправильный bind address**: Приложение должно быть доступно извне контейнера:
  ```ruby
  # config/puma.rb
  bind "tcp://0.0.0.0:#{ENV.fetch("PORT") { 3000 }}"
  ```

- [ ] **Проблемы с CORS**: Проверьте настройки CORS, если ваше приложение обслуживает API.

- [ ] **Проблемы с SSL/TLS**: render.com предоставляет автоматический SSL, но убедитесь, что ваше приложение настроено для работы через HTTPS.

## Чеклист для успешного деплоя

- [ ] **Локальный тест Docker-образа**:
  ```bash
  docker build -t my-rails-app .
  docker run -p 3000:3000 -e PORT=3000 -e RAILS_MASTER_KEY=$(cat config/master.key) my-rails-app
  ```

- [ ] **Проверка секретов**: Убедитесь, что все секреты и переменные окружения настроены.

- [ ] **Проверка базы данных**: Убедитесь, что соединение с базой данных работает.

- [ ] **Проверка ассетов**: Убедитесь, что статические файлы обслуживаются правильно.

- [ ] **Мониторинг логов**: После деплоя внимательно проверьте логи на наличие ошибок.

- [ ] **Оптимизация размера образа**: Используйте многоэтапную сборку для уменьшения размера образа.

- [ ] **Настройка healthcheck**: Добавьте проверку работоспособности для контейнера:
  ```dockerfile
  HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 CMD curl -f http://localhost:$PORT/ || exit 1
  ```

Эти рекомендации должны помочь диагностировать и исправить большинство проблем при деплое Rails-приложения через Docker, особенно на платформе render.com. 