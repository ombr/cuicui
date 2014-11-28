# RegistrationsController
class RegistrationsController < Devise::RegistrationsController
  layout 'admin'

  # Code coming from devise. with hack to send reset password or resend confirmation.
  def create
    build_resource(sign_up_params)
    if resource.save
      # default devise code
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        analytics_track('Registred', email: resource.email)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      resource = User.find_by_email(params['user']['email'])
      if resource
        if resource.confirmed?
          resource.send_reset_password_instructions
          set_flash_message :notice, :"signed_up_but_password_reset_sent" if is_flashing_format?
          respond_with resource, location: new_user_session_path
        else
          resource.send_confirmation_instructions
          set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
          respond_with resource, location: new_user_session_path
        end
      else
        # Default devise code
        clean_up_passwords resource
        @validatable = devise_mapping.validatable?
        if @validatable
          @minimum_password_length = resource_class.password_length.min
        end
        render :new
      end
    end
  end

  def destroy
    resource.update password: SecureRandom.hex
    Resque.enqueue ObjectDeletion, 'User', resource.id
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_flashing_format?
    yield resource if block_given?
    respond_with_navigational(resource) do
      redirect_to after_sign_out_path_for(resource_name)
    end
  end

  def update_resource(resource, params)
    if resource.password?
      resource.update_with_password(params)
    else
      resource.update(params)
    end
  end

  private

  def after_update_path_for(_resource)
    edit_user_registration_path
  end
end
