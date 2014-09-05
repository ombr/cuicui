# RegistrationsController
class RegistrationsController < Devise::RegistrationsController
  layout 'admin'

  def create
    build_resource(sign_up_params)
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        if resource.confirmed?
          set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        else
          self.resource = resource_class.send_confirmation_instructions(resource_params)
          if successfully_sent?(resource)
            return respond_with({}, location: after_resending_confirmation_instructions_path_for(resource_name))
          else
            return respond_with(resource)
          end
        end
      end
    else
      render :new
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
end
