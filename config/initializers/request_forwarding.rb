# frozen_string_literal: true

# Конфигурация для корректного определения IP адресов и протоколов (HTTP/HTTPS)
# при использовании прокси на Render.com

# Пропускаем настройку в режиме прекомпиляции активов
unless Rails.application.config.respond_to?(:precompiling_assets) && Rails.application.config.precompiling_assets

  # Включаем доверенные прокси для Render.com
  trusted_proxies = [
    # Render.com использует внутренние прокси с частными IP адресами
    /^127\.0\.0\.1$/,
    /^::1$/,
    /^10\.\d+\.\d+\.\d+$/,
    /^172\.(1[6-9]|2\d|3[0-1])\.\d+\.\d+$/,
    /^192\.168\.\d+\.\d+$/
  ]

  # Настраиваем доверенные прокси на уровне конфигурации
  Rails.application.config.action_dispatch.trusted_proxies = ActionDispatch::RemoteIp::TRUSTED_PROXIES + 
    trusted_proxies + 
    (ENV["TRUSTED_PROXIES"]&.split(",") || [])

  # Отключаем проверку подделки IP, чтобы заголовки X-Forwarded-* работали корректно
  Rails.application.config.action_dispatch.ip_spoofing_check = false

  Rails.application.config.after_initialize do
    # Пропускаем выполнение в режиме прекомпиляции активов
    unless Rails.application.config.respond_to?(:assets_precompile_mode) && 
           Rails.application.config.assets_precompile_mode
      
      # Лог о применении конфигурации
      Rails.logger.info "Применены настройки для обработки проксированных запросов на Render.com"
      
      # Вместо изменения middleware stack (что приводит к ошибке с замороженным массивом),
      # настраиваем конфигурацию и оставляем существующий ActionDispatch::RemoteIp middleware
      if defined?(ActionDispatch::RemoteIp)
        Rails.logger.info "Настроены доверенные прокси для ActionDispatch::RemoteIp"
      end
    end
  end
  
end
