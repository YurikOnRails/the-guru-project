# frozen_string_literal: true

# Конфигурация SolidCable для правильного подключения к базе данных
# Патч решает проблему с отсутствием конфигурации cable в production

# Пропускаем настройку SolidCable в режиме прекомпиляции активов
if !Rails.configuration.precompiling_assets

  Rails.application.config.to_prepare do
    # Проверяем, что не находимся в режиме прекомпиляции активов
    unless Rails.application.config.respond_to?(:assets_precompile_mode) &&
           Rails.application.config.assets_precompile_mode

      if defined?(SolidCable)
        # Настраиваем SolidCable для использования primary соединения вместо cable
        Rails.logger.info "Настройка SolidCable для использования primary соединения"

        # Переопределяем соединение в Record модели SolidCable
        if defined?(SolidCable::Record)
          SolidCable::Record.class_eval do
            # Если мы в production и нет специального соединения cable,
            # используем primary
            connects_to database: { writing: :primary, reading: :primary }
          end
        end
      end
    end
  end

end
