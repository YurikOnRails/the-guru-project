class Users::SessionsController < Devise::SessionsController
  def create
    super do |resource|
      unless resource.admin?
        flash.delete(:notice)
        flash[:notice] = "Привет, #{resource.full_name}!"
      end
    end
  end
end
