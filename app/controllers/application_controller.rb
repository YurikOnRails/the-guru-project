class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  def default_url_options
    {
      lang: (I18n.locale == I18n.default_locale ? nil : I18n.locale),
      protocol: (Rails.env.production? ? "https" : nil)
    }.compact
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
end
