# frozen_string_literal: true

# Запасной инициализатор для случаев, когда SolidCache не может быть настроен корректно
# Этот файл создан для обеспечения надежного запуска приложения даже при проблемах с кэш-хранилищем

Rails.application.config.after_initialize do
  if Rails.env.production?
    begin
      # Проверяем, что SolidCache может быть инициализирован
      if defined?(SolidCache) && defined?(SolidCache::Store)
        Rails.logger.info "SolidCache проверка в запасном инициализаторе"

        # В случае проблем с SolidCache, этот код будет выполнен позже
        # и может заменить кеш-хранилище на более простое
        Rails.application.reloader.to_prepare do
          begin
            # Убеждаемся, что SolidCache работает
            Rails.cache.write("solid_cache_test", "test")
            Rails.logger.info "SolidCache успешно инициализирован"
          rescue => e
            # Если возникла ошибка, заменяем кеш-хранилище на память
            Rails.logger.error "Ошибка при инициализации SolidCache: #{e.message}"
            Rails.logger.warn "Переключение на кеш-хранилище в памяти"

            # Заменяем кеш-хранилище на :memory_store
            Rails.application.config.cache_store = :memory_store, { size: 64.megabytes }
            Rails.cache = ActiveSupport::Cache.lookup_store(Rails.application.config.cache_store)
          end
        end
      end
    rescue => e
      Rails.logger.error "Ошибка в solid_cache_fallback.rb: #{e.message}"
    end
  end
end
