# frozen_string_literal: true

# Конфигурация для корректного определения IP адресов и протоколов (HTTP/HTTPS)
# при использовании прокси на Render.com

Rails.application.config.after_initialize do
  # Отмечаем заголовки, которые позволяют определять настоящий IP клиента
  # Render.com использует X-Forwarded-For
  Rails.application.config.action_dispatch.trusted_proxies = ActionDispatch::RemoteIp::TRUSTED_PROXIES +
    (ENV["TRUSTED_PROXIES"]&.split(",") || [])
  
  # Доверяем заголовкам X-Forwarded-For, X-Forwarded-Host и X-Forwarded-Port
  # для определения правильного IP адреса и порта
  Rails.application.config.action_dispatch.ip_spoofing_check = false
  
  # Добавляем адреса прокси, используемые на Render.com
  # Если у вас есть конкретные IP адреса Render.com, добавьте их сюда
  Rails.application.config.middleware.insert_before(ActionDispatch::RemoteIp, ActionDispatch::RemoteIp, 
    proxies: [
      # Render.com использует внутренние прокси с частными IP адресами
      /^127\.0\.0\.1$/,
      /^::1$/,
      /^10\.\d+\.\d+\.\d+$/,
      /^172\.(1[6-9]|2\d|3[0-1])\.\d+\.\d+$/,
      /^192\.168\.\d+\.\d+$/
    ]
  )
  
  # Удаляем оригинальный RemoteIp middleware, так как мы добавили свой с нужными настройками
  Rails.application.config.middleware.delete(ActionDispatch::RemoteIp)
  
  # Лог о применении конфигурации
  Rails.logger.info "Применены настройки для обработки проксированных запросов на Render.com"
end 