# frozen_string_literal: true

# Отключаем сложные features при прекомпиляции ассетов
# Это помогает избежать проблем, когда полная инициализация не требуется

# Проверяем, находимся ли в режиме прекомпиляции активов
is_precompiling_assets = defined?(Rake) &&
                         Rake.application&.top_level_tasks&.any? { |task| task.include?("assets:precompile") }

# Если мы прекомпилируем ассеты, отключаем некоторые инициализаторы
if is_precompiling_assets
  puts "Режим прекомпиляции активов: отключаем некоторые инициализаторы"

  # Отключаем сложные или опасные инициализаторы
  Rails.application.config.solid_cable_enabled = false
  Rails.application.config.solid_cache_enabled = false
  Rails.application.config.proxy_patching_enabled = false

  # Указываем, что мы в режиме прекомпиляции
  Rails.application.config.assets_precompile_mode = true
end

# Это простой инициализатор, который работает всегда и указывает другим инициализаторам,
# что мы в режиме прекомпиляции
Rails.configuration.precompiling_assets = is_precompiling_assets
