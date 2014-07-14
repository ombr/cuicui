class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  skip_after_filter :intercom_rails_auto_include

  rescue_from CanCan::AccessDenied do |exception|
    flash[:danger] = exception.message
    redirect_to new_user_session_path
  end

  def load_site_from_host
    Site.friendly.find(request.subdomain)
  end

  private

    def after_sign_out_path_for(resource_or_scope)
      new_user_session_path
    end

    def after_sign_in_path_for(resource_or_scope)
      sites_path
    end
end
