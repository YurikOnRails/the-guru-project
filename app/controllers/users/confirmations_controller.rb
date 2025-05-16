class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  def new
    super
  end

  # POST /resource/confirmation
  def create
    super
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    Rails.logger.info "Received confirmation token: #{params[:confirmation_token]}"
    
    if params[:confirmation_token].blank?
      flash[:alert] = "Токен подтверждения отсутствует"
      redirect_to root_path and return
    end
    
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      set_flash_message!(:notice, :confirmed)
      sign_in(resource)
      respond_with_navigational(resource) { redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      flash[:alert] = I18n.t("devise.confirmations.error",
                            message: resource.errors.full_messages.to_sentence,
                            default: resource.errors.full_messages.to_sentence)
      redirect_to new_user_session_path
    end
  end

  protected

  # The path used after resending confirmation instructions.
  def after_resending_confirmation_instructions_path_for(resource_name)
    is_navigational_format? ? new_session_path(resource_name) : "/"
  end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    root_path
  end
end
