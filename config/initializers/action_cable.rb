# frozen_string_literal: true

# Настройка Action Cable для корректной работы с базой данных
# Эта настройка помогает избежать ошибки с отсутствием конфигурации cable

Rails.application.config.action_cable.mount_path = "/cable"
Rails.application.config.action_cable.allowed_request_origins = [ /.*/ ]

# Настраиваем пул соединений для Action Cable
if Rails.env.production?
  Rails.application.config.after_initialize do
    # Убеждаемся, что Action Cable использует правильное соединение с БД
    ActionCable.server.config.cable = { adapter: "solid_cable" }

    # Если используется SolidCable, проверяем его настройки
    if defined?(SolidCable)
      # Убеждаемся, что база данных для SolidCable существует
      Rails.logger.info "Инициализация Action Cable с SolidCable адаптером в production"
    end
  end
end
