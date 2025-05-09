# frozen_string_literal: true

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

# Более безопасный патч для Devise, чтобы использовать ENV или фиксированные значения
# если credentials недоступны
module DeviseSecretKeyPatch
  def find
    # Пытаемся сначала получить ключ из переменной окружения
    return ENV["DEVISE_SECRET_KEY"] if ENV["DEVISE_SECRET_KEY"].present?

    begin
      # Пытаемся использовать стандартный метод через super
      super
    rescue StandardError => e
      # Логируем ошибку более детально
      Rails.logger.warn "WARNING: Error in Devise secret key finder: #{e.class} - #{e.message}"
      Rails.logger.warn "Backtrace: #{e.backtrace[0..5].join("\n")}" if e.backtrace.present?
      
      # Если credentials недоступны, используем ENV или генерируем ключ
      Rails.logger.warn "Using alternative method for Devise secret key"

      # Используем SECRET_KEY_BASE если доступен
      if ENV["SECRET_KEY_BASE"].present?
        # Используем его как основу для Devise secret key
        key = Digest::SHA256.hexdigest(ENV["SECRET_KEY_BASE"] + "devise_key")
        Rails.logger.info "Using SECRET_KEY_BASE as base for Devise secret key"
        return key
      end
      
      # Последний вариант - генерируем случайный ключ
      if Rails.env.production?
        Rails.logger.warn "WARNING: Using randomly generated DEVISE_SECRET_KEY. This is not secure for persistent sessions!"
        Rails.logger.warn "Please set DEVISE_SECRET_KEY or SECRET_KEY_BASE environment variable."
      end
      
      # Генерируем случайный ключ, который будет использоваться только для этого запуска
      SecureRandom.hex(64)
    end
  end
end

# Устанавливаем лог-уровень, чтобы видеть информацию о патче
old_log_level = Rails.logger.level
Rails.logger.level = Logger::INFO

# Выборочно патчим Devise::SecretKeyFinder только если он определен
if defined?(Devise::SecretKeyFinder)
  Rails.logger.info "Applying DeviseSecretKeyPatch"
  Devise::SecretKeyFinder.prepend(DeviseSecretKeyPatch)
  Rails.logger.info "DeviseSecretKeyPatch applied successfully"
else
  Rails.logger.info "Devise::SecretKeyFinder not defined, patch not applied"
end

# Возвращаем прежний уровень логирования
Rails.logger.level = old_log_level

# Добавляем метод, который проверяет, что все необходимые ключи для Devise доступны
Rails.application.config.after_initialize do
  if defined?(Devise)
    begin
      Rails.logger.info "Testing Devise secret key access..."
      key = Devise.secret_key
      Rails.logger.info "Devise secret key is available"
    rescue => e
      Rails.logger.error "ERROR: Failed to access Devise secret key: #{e.message}"
      Rails.logger.error "Please ensure DEVISE_SECRET_KEY or SECRET_KEY_BASE is set in environment variables"
    end
  end
end
