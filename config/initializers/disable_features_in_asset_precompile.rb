# frozen_string_literal: true

# Отключаем сложные features при прекомпиляции ассетов
# Это помогает избежать проблем, когда полная инициализация не требуется

# Проверяем, находимся ли в режиме прекомпиляции активов
# Используем значение из precompile_mode_check.rb если оно доступно
if Rails.application.config.respond_to?(:precompiling_assets) && Rails.application.config.precompiling_assets
  puts "Режим прекомпиляции активов: отключаем сложные инициализаторы"

  # Отключаем сложные или опасные инициализаторы
  Rails.application.config.solid_cable_enabled = false
  Rails.application.config.solid_cache_enabled = false
  Rails.application.config.proxy_patching_enabled = false
  
  # Добавляем переменные окружения для тех инициализаторов, которые их проверяют
  ENV["SKIP_COMPLEX_INITIALIZERS"] = "true"
  ENV["RAILS_PRECOMPILE_MODE"] = "true"
end
