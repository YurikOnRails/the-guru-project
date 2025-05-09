# Этот файл отключает доступ к credentials.yml.enc во время компиляции ассетов
# чтобы избежать ошибок, связанных с отсутствием master.key

# Проверяем, запущен ли процесс для assets:precompile
if $PROGRAM_NAME =~ /assets:(?:precompile|clean)/ || ENV['PRECOMPILING_ASSETS']
  # Переопределяем метод credentials для Application
  module DisableCredentialsInPrecompile
    def credentials
      # Возвращаем пустой объект без попыток расшифровки
      ActiveSupport::OrderedOptions.new.tap do |options|
        options.secret_key_base = ENV.fetch("SECRET_KEY_BASE", "dummy_key_for_precompile")
      end
    end
  end
  
  # Применяем патч к Rails.application
  if defined?(Rails) && Rails.respond_to?(:application) && Rails.application
    Rails.logger.info "Disabled credentials during asset precompilation"
    Rails.application.singleton_class.prepend(DisableCredentialsInPrecompile)
  end
  
  # Также сообщаем об этом
  puts "Note: Credentials disabled during asset precompilation (using dummy values)"
end 