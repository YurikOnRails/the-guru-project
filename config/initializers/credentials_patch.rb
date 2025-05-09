# Этот патч перехватывает ошибки при попытке расшифровать credentials
# и делает фолбэк на переменные окружения

# Патч для перехвата ошибок при расшифровке данных
module EncryptedFilePatch
  def read
    begin
      # Пытаемся использовать оригинальный метод
      super
    rescue ActiveSupport::MessageEncryptor::InvalidMessage => e
      Rails.logger.warn "WARNING: Cannot decrypt #{content_path} - using fallback mechanism"
      
      # Если это credentials, возвращаем пустой YAML
      if content_path.to_s.end_with?('credentials.yml.enc')
        "---\n"
      else
        # Для других файлов просто возвращаем пустую строку
        ""
      end
    rescue => e
      Rails.logger.error "ERROR: Unexpected error reading encrypted file: #{e.class} - #{e.message}"
      # Возвращаем пустую строку в случае любой ошибки
      ""
    end
  end
end

# Патч для подмены содержимого credentials
module CredentialsPatch
  def config
    begin
      # Сначала пытаемся использовать оригинальный метод
      original_config = super
      
      # Проверим, что данные доступны, чтобы выявить случаи, когда credentials пустые
      original_config&.to_h
      
      # Если все в порядке, используем оригинальные данные
      original_config
    rescue StandardError => e
      Rails.logger.warn "WARNING: Cannot use credentials - using ENV variables instead: #{e.message}"
      
      # Создаем ActiveSupport::OrderedOptions для имитации структуры credentials
      fallback = ActiveSupport::OrderedOptions.new
      
      # Добавляем базовые атрибуты из ENV переменных
      fallback.secret_key_base = ENV["SECRET_KEY_BASE"]
      
      # Добавляем другие часто используемые атрибуты
      # AWS
      aws = ActiveSupport::OrderedOptions.new
      aws.access_key_id = ENV["AWS_ACCESS_KEY_ID"]
      aws.secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]
      aws.region = ENV["AWS_REGION"]
      fallback.aws = aws
      
      # Почтовый сервер
      smtp = ActiveSupport::OrderedOptions.new
      smtp.address = ENV["SMTP_SERVER"]
      smtp.port = ENV["SMTP_PORT"]
      smtp.domain = ENV["SMTP_DOMAIN"]
      smtp.user_name = ENV["SMTP_USERNAME"]
      smtp.password = ENV["SMTP_PASSWORD"]
      fallback.smtp = smtp
      
      # Другие API ключи
      api_keys = ActiveSupport::OrderedOptions.new
      api_keys.stripe = ENV["STRIPE_API_KEY"]
      api_keys.google_maps = ENV["GOOGLE_MAPS_API_KEY"]
      fallback.api_keys = api_keys
      
      # Специфичные для Devise
      devise = ActiveSupport::OrderedOptions.new
      devise.secret_key = ENV["DEVISE_SECRET_KEY"]
      fallback.devise = devise
      
      # Возвращаем созданный объект вместо реальных credentials
      fallback
    end
  end
  
  # Патч для метода options, который используется для доступа к секциям
  def options
    begin
      super
    rescue => e
      Rails.logger.warn "WARNING: Error accessing credentials options: #{e.message}"
      config
    end
  end
end

# Применяем патчи только если классы доступны
if defined?(ActiveSupport::EncryptedFile)
  Rails.logger.info "Applying EncryptedFilePatch to ActiveSupport::EncryptedFile"
  ActiveSupport::EncryptedFile.prepend(EncryptedFilePatch)
end

if defined?(ActiveSupport::EncryptedConfiguration)
  Rails.logger.info "Applying CredentialsPatch to ActiveSupport::EncryptedConfiguration"
  ActiveSupport::EncryptedConfiguration.prepend(CredentialsPatch)
end 