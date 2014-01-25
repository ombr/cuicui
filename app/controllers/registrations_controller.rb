class RegistrationsController < Devise::RegistrationsController
  layout 'admin'
  def new
    return redirect_to new_user_session_path if User.count > 0
    super
  end
end
