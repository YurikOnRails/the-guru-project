# frozen_string_literal: true

# Этот файл определяет, запущено ли приложение в режиме прекомпиляции assets.
# Он должен загружаться раньше, чем все остальные инициализаторы.

module PrecompileModeDetector
  # Проверяем, находимся ли в режиме прекомпиляции активов
  def self.precompiling_assets?
    return true if ENV["RAILS_PRECOMPILE_MODE"] == "true"
    
    if defined?(Rake) && Rake.respond_to?(:application) && Rake.application
      return Rake.application.top_level_tasks.any? do |task|
        task.include?("assets:precompile") || 
        task.include?("assets:clean") ||
        task.include?("webpacker:compile")
      end
    end
    
    false
  end
  
  # Возвращает статус режима прекомпиляции
  def self.status_message
    if precompiling_assets?
      "Rails запущен в режиме прекомпиляции активов - отключаем сложные инициализаторы"
    else
      "Rails запущен в обычном режиме"
    end
  end
end

# Устанавливаем глобальную переменную для проверки в других инициализаторах
Rails.application.config.precompiling_assets = PrecompileModeDetector.precompiling_assets?

# Выводим сообщение о режиме, если мы в прекомпиляции
if Rails.application.config.precompiling_assets
  puts PrecompileModeDetector.status_message
  
  # Устанавливаем режим прекомпиляции для отключения различных компонентов
  Rails.application.config.assets_precompile_mode = true
end 