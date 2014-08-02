# PasswordsController
class PasswordsController < Devise::PasswordsController
  layout 'admin'
  def update
    super
    resource.confirm!
  end
end
