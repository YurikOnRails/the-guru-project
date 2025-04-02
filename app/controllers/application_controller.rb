class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  helper_method :current_user, :logged_in?

  private

  def authenticate_user!
    unless logged_in?
      cookies[:target_url] = request.url if request.get?
      redirect_to login_path, alert: "Please log in to continue"
    end

    cookies[:email] = current_user&.email
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end
end
