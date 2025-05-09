# frozen_string_literal: true

# Патч для ActionDispatch::SSL middleware для корректной работы на Render.com
# Проблема может быть в том, что Render.com терминирует SSL на уровне прокси,
# но ActionDispatch::SSL может неправильно обрабатывать заголовки

Rails.application.config.after_initialize do
  if defined?(ActionDispatch::SSL)
    module ActionDispatchSSLPatch
      def call(env)
        # Проверяем заголовки, которые Render.com добавляет для проксированных запросов
        request = ActionDispatch::Request.new(env)
        
        # Если запрос уже пришел через HTTPS или имеет специальный заголовок от Render.com
        if request.ssl? || 
           env["HTTP_X_FORWARDED_PROTO"] == "https" || 
           env["HTTP_X_FORWARDED_SSL"] == "on" ||
           env["HTTP_CF_VISITOR"]&.include?("https") # Для Cloudflare
          
          # Пропускаем проверку SSL и обработку редиректов
          # Просто вызываем следующее middleware в цепочке
          return @app.call(env)
        end
        
        # В противном случае, используем стандартное поведение
        super
      end
    end
    
    # Применяем патч к middleware SSL для обхода проблем с прокси
    Rails.logger.info "Применяем патч ActionDispatchSSLPatch для ActionDispatch::SSL"
    ActionDispatch::SSL.prepend(ActionDispatchSSLPatch)
  end
  
  # Проверяем, есть ли ActionDispatch::AssumeSSL в цепочке middleware и патчим его тоже
  if defined?(ActionDispatch::AssumeSSL)
    module ActionDispatchAssumeSSLPatch
      def call(env)
        # Устанавливаем "https" в scheme для всех запросов
        request = ActionDispatch::Request.new(env)
        request.set_header("rack.url_scheme", "https")
        
        # Продолжаем цепочку middleware
        @app.call(env)
      end
    end
    
    # Применяем патч к AssumeSSL middleware
    Rails.logger.info "Применяем патч ActionDispatchAssumeSSLPatch для ActionDispatch::AssumeSSL"
    ActionDispatch::AssumeSSL.prepend(ActionDispatchAssumeSSLPatch)
  end
end 