class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      flash[:notice] = "Добро пожаловать, #{resource.first_name}!"
    end
  end
end
