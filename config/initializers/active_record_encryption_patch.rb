# Патч для ActiveRecord::Encryption, чтобы он работал без credentials
# Он будет использовать переменные окружения или SECRET_KEY_BASE

# Перехватываем методы получения ключей шифрования
module ActiveRecordEncryptionPatch
  def primary_key
    ENV["RAILS_ENCRYPTION_PRIMARY_KEY"] || derive_key_from_secret_key_base("primary")
  end

  def deterministic_key
    ENV["RAILS_ENCRYPTION_DETERMINISTIC_KEY"] || derive_key_from_secret_key_base("deterministic")
  end

  def key_derivation_salt
    ENV["RAILS_ENCRYPTION_KEY_DERIVATION_SALT"] || derive_key_from_secret_key_base("salt")
  end

  private

  def derive_key_from_secret_key_base(key_type)
    # Проверяем наличие SECRET_KEY_BASE
    if ENV["SECRET_KEY_BASE"].present?
      # Создаем производный ключ на основе SECRET_KEY_BASE и типа ключа
      case key_type
      when "primary"
        ENV["SECRET_KEY_BASE"][0..31]
      when "deterministic"
        Digest::SHA256.hexdigest(ENV["SECRET_KEY_BASE"])[0..31]
      when "salt"
        Digest::SHA256.hexdigest(ENV["SECRET_KEY_BASE"] + "salt")[0..31]
      else
        # В случае неизвестного типа ключа генерируем случайный ключ
        SecureRandom.hex(16)
      end
    else
      # Если SECRET_KEY_BASE не установлен, просто генерируем случайный ключ
      Rails.logger.warn "WARNING: No SECRET_KEY_BASE for ActiveRecord::Encryption, using random key for #{key_type}"
      SecureRandom.hex(16)
    end
  end
end

# Применяем патч только если класс определен
if defined?(ActiveRecord::Encryption::Configurable)
  Rails.logger.info "Applying ActiveRecordEncryptionPatch"
  ActiveRecord::Encryption::Configurable.prepend(ActiveRecordEncryptionPatch)
end
