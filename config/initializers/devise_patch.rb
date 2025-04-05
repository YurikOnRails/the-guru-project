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
