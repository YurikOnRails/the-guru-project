# Временный патч для совместимости Devise с Rails 8.0.1
# Добавляет метод action, который был удален в Rails 8.0.1
if Rails.version.start_with?("8.0")
  module Rails
    class Application
      class Configuration
        def action
          @action ||= ActiveSupport::OrderedOptions.new
        end
      end
    end
  end
end

# frozen_string_literal: true

# Более безопасный патч для Devise, чтобы использовать ENV или фиксированные значения
# если credentials недоступны
module DeviseSecretKeyPatch
  def find
    # Пытаемся сначала получить ключ из переменной окружения
    return ENV["DEVISE_SECRET_KEY"] if ENV["DEVISE_SECRET_KEY"].present?

    begin
      # Пытаемся использовать стандартный метод через super
      super
    rescue ActiveSupport::MessageEncryptor::InvalidMessage => e
      # Если credentials недоступны, используем ENV или генерируем ключ
      Rails.logger.warn "WARNING: Rails credentials unavailable, using alternative for Devise secret key"
      
      # Последний вариант - генерируем случайный ключ
      if Rails.env.production?
        Rails.logger.warn "WARNING: Using randomly generated DEVISE_SECRET_KEY. This is not secure for persistent sessions!"
        Rails.logger.warn "Please set DEVISE_SECRET_KEY environment variable."
      end
      
      # Убеждаемся, что SECRET_KEY_BASE установлен и используем его если нет DEVISE_SECRET_KEY
      if ENV["SECRET_KEY_BASE"].present?
        # Используем его как основу для Devise secret key
        Digest::SHA256.hexdigest(ENV["SECRET_KEY_BASE"] + "devise_key")
      else
        # Генерируем случайный ключ, который будет использоваться только для этого запуска
        SecureRandom.hex(64)
      end
    rescue => e
      # Перехватываем любые другие ошибки
      Rails.logger.error "ERROR in Devise secret key finder: #{e.class} - #{e.message}"
      # В крайнем случае генерируем случайный ключ
      SecureRandom.hex(64)
    end
  end
end

# Выборочно патчим Devise::SecretKeyFinder только если он определен
if defined?(Devise::SecretKeyFinder)
  Rails.logger.info "Applying DeviseSecretKeyPatch"
  Devise::SecretKeyFinder.prepend(DeviseSecretKeyPatch)
end
