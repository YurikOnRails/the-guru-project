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
    # Сначала пытаемся использовать стандартный метод через super
    super
  rescue ActiveSupport::MessageEncryptor::InvalidMessage
    # Если credentials недоступны, используем ENV или генерируем ключ
    Rails.logger.warn "WARNING: Rails credentials unavailable, using alternative for Devise secret key"
    
    if ENV["DEVISE_SECRET_KEY"].present?
      ENV["DEVISE_SECRET_KEY"]
    else
      if Rails.env.production?
        Rails.logger.warn "WARNING: Using randomly generated DEVISE_SECRET_KEY. This is not secure for persistent sessions!"
        Rails.logger.warn "Please set DEVISE_SECRET_KEY environment variable."
      end
      # Генерируем случайный ключ, который будет использоваться только для этого запуска
      SecureRandom.hex(64)
    end
  end
end

# Выборочно патчим Devise::SecretKeyFinder только если он определен
if defined?(Devise::SecretKeyFinder)
  Rails.logger.info "Applying DeviseSecretKeyPatch"
  Devise::SecretKeyFinder.prepend(DeviseSecretKeyPatch)
end
