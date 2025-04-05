class Users::SessionsController < Devise::SessionsController
  def create
    super do |resource|
      unless resource.admin?
        set_flash_message!(:notice, :signed_in, username: resource.full_name)
      end
    end
  end
end 