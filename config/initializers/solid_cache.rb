# frozen_string_literal: true

# Конфигурация SolidCache для правильного подключения к базе данных в production
# Патч решает проблему с отсутствием конфигурации cache в production

# Пропускаем настройку SolidCache в режиме прекомпиляции активов
unless Rails.application.config.respond_to?(:precompiling_assets) && Rails.application.config.precompiling_assets

  # Определяем патч для SolidCache::Record
  module SolidCachePrimaryConnectionPatch
    def self.apply!
      if defined?(SolidCache::Record)
        # Переопределяем метод соединения с БД, чтобы использовать primary
        Rails.logger.info "Применяем патч SolidCachePrimaryConnectionPatch"

        # Открываем singleton class для переопределения self.connects_to
        SolidCache::Record.singleton_class.prepend(Module.new do
          def inherited(subclass)
            # Переопределяем, чтобы не вызывать исходный connects_to
            subclass.connects_to database: { writing: :primary, reading: :primary }
            super
          end
        end)

        # Напрямую меняем connections_to для основного класса
        SolidCache::Record.connects_to database: { writing: :primary, reading: :primary }
      end
    end
  end

  # Применяем патч на старте приложения
  Rails.application.config.after_initialize do
    # Не применяем патч, если отключен в режиме прекомпиляции
    unless Rails.application.config.respond_to?(:assets_precompile_mode) && Rails.application.config.assets_precompile_mode
      SolidCachePrimaryConnectionPatch.apply! if Rails.env.production?

      # Проверяем работоспособность SolidCache
      if defined?(SolidCache) && Rails.env.production?
        Rails.logger.info "SolidCache настроен для использования в production"
      end
    end
  end

end
