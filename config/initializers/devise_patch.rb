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

# Патч для Devise, чтобы использовать либо credentials, либо ENV переменные,
# либо фиксированное значение для secret_key, если credentials недоступны
module Devise
  module SecretKeyFinder
    alias_method :original_find, :find
    
    def find
      # Сначала пытаемся использовать стандартный метод
      original_find
    rescue ActiveSupport::MessageEncryptor::InvalidMessage => e
      # Если credentials недоступны, используем ENV или фиксированное значение
      if ENV["DEVISE_SECRET_KEY"].present?
        ENV["DEVISE_SECRET_KEY"]
      else
        # В production нужно будет задать DEVISE_SECRET_KEY в переменных окружения
        # Это временное решение для успешного деплоя
        if Rails.env.production?
          puts "WARNING: Using hardcoded DEVISE_SECRET_KEY in production. This is not secure!"
          puts "Please set DEVISE_SECRET_KEY environment variable."
        end
        # Генерируем случайный ключ, который будет использоваться только для этого запуска
        SecureRandom.hex(64)
      end
    end
  end
end
