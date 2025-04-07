class Users::SessionsController < Devise::SessionsController
  def create
    super do |resource|
      flash.delete(:notice)
      flash[:notice] = "Приветствую, #{resource.full_name}!!!"
    end
  end
end
