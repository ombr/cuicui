class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    flash[:danger] = exception.message
    redirect_to new_user_session_path
  end

  private

    def after_sign_in_path_for(resource_or_scope)
      first_page = Site.first.pages.first
      if first_page
        edit_page_path id: first_page
      else
        new_site_page_path site_id: Site.first
      end
    end
end
