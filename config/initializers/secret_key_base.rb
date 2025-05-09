# Этот инициализатор обеспечивает наличие secret_key_base 
# для различных сценариев, включая компиляцию ассетов

# Если мы находимся в процессе компиляции ассетов, используем dummy ключ
if defined?(Sprockets) && $PROGRAM_NAME.end_with?('assets:precompile') || $PROGRAM_NAME.end_with?('assets:clean')
  Rails.application.config.secret_key_base = ENV.fetch("SECRET_KEY_BASE", "dummy_precompile_key_only_for_assets")
# Или если secret_key_base не определен другим способом, но есть ENV переменная
elsif !Rails.application.config.respond_to?(:secret_key_base) && ENV["SECRET_KEY_BASE"].present?
  Rails.application.config.secret_key_base = ENV["SECRET_KEY_BASE"]
end 