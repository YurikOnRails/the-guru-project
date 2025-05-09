# frozen_string_literal: true

# Патч для ActionDispatch::SSL middleware для корректной работы на Render.com
# Проблема может быть в том, что Render.com терминирует SSL на уровне прокси,
# но ActionDispatch::SSL может неправильно обрабатывать заголовки

# Пропускаем настройку SSL в режиме прекомпиляции активов
unless Rails.application.config.respond_to?(:precompiling_assets) && Rails.application.config.precompiling_assets

  # Более безопасный подход: не патчим сам middleware класс, а настраиваем опции для SSL через конфигурацию
  Rails.application.config.ssl_options = {
    redirect: { 
      exclude: ->(request) { 
        # Не редиректим, если запрос уже пришел через HTTPS или от прокси с HTTPS
        request.ssl? || 
        request.headers["X-Forwarded-Proto"] == "https" || 
        request.headers["X-Forwarded-SSL"] == "on" || 
        request.headers["CF-Visitor"]&.include?("https")
      }
    },
    hsts: { expires: 180.days, subdomains: true }
  }

  Rails.application.config.after_initialize do
    # Пропускаем выполнение в режиме прекомпиляции активов
    unless Rails.application.config.respond_to?(:assets_precompile_mode) && 
           Rails.application.config.assets_precompile_mode
      
      Rails.logger.info "Применены настройки для ActionDispatch::SSL через ssl_options"
      
      # Если ActionDispatch::AssumeSSL уже в стеке, дополнительно логируем
      if defined?(ActionDispatch::AssumeSSL) && Rails.application.config.assume_ssl
        Rails.logger.info "Обнаружен ActionDispatch::AssumeSSL в middleware stack"
      end
      
      # Добавляем логирование для обработки SSL запросов
      if Rails.env.production?
        Rails.logger.info "SSL настройки в production: force_ssl=#{Rails.application.config.force_ssl}, assume_ssl=#{Rails.application.config.assume_ssl}"
      end
    end
  end
  
end
