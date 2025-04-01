class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @current_user ||= User.first  # Добавил как временное решение, чтобы всегда использовать первого пользователя
  end
end
