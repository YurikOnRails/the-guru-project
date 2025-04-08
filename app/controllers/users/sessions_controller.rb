class Users::SessionsController < Devise::SessionsController
  def create
    super do |resource|
      flash[:notice] = "Привет, #{resource.first_name}!"
    end
  end
end
