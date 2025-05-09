class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Обработка стандартных исключений в production-окружении
  if Rails.env.production?
    rescue_from StandardError, with: :internal_server_error
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActionController::RoutingError, with: :not_found
    rescue_from ActionController::InvalidAuthenticityToken, with: :unprocessable_entity
  end

  def default_url_options
    I18n.locale == I18n.default_locale ? {} : { lang: I18n.locale }
  end

  protected

  # Перенаправление администраторов на страницу /admin/tests после логина
  def after_sign_in_path_for(_resource)
    if current_user.admin?
      admin_tests_path
    else
      root_path
    end
  end

  # Добавление разрешенных параметров для Devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :first_name, :last_name ])
  end

  private

  def set_locale
    I18n.locale = I18n.locale_available?(params[:lang]) ? params[:lang] : I18n.default_locale
  end

  # Методы для обработки исключений
  def not_found
    render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
  end

  def unprocessable_entity
    render file: "#{Rails.root}/public/422.html", status: :unprocessable_entity, layout: false
  end

  def internal_server_error(exception)
    Rails.logger.error("Internal Server Error: #{exception.message}\n#{exception.backtrace.join("\n")}")
    render file: "#{Rails.root}/public/500.html", status: :internal_server_error, layout: false
  end
end
