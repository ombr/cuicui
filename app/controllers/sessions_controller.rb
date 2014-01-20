class SessionsController < Devise::SessionsController
  def new
    return redirect_to new_user_registration_path if User.count == 0
    super
  end
end
