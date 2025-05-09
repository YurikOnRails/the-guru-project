# frozen_string_literal: true

# Настройки механизма автозагрузки Zeitwerk
Rails.autoloaders.main.on_load_error do |file, error|
  Rails.logger.error "Ошибка автозагрузки Zeitwerk: #{error.message} в файле #{file}"

  # Логируем детальную информацию об ошибке в продакшене
  # но не прерываем выполнение приложения
  if Rails.env.production?
    # Вернуть true означает, что ошибка будет проигнорирована
    # Это позволит приложению продолжить работу даже при ошибках Zeitwerk
    true
  else
    # В других окружениях ошибки не игнорируются, чтобы разработчики могли их исправить
    false
  end
end
