class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  skip_after_filter :intercom_rails_auto_include

  if ENV['AUTH_NAME'] && ENV['AUTH_PASS']
    http_basic_authenticate_with name: ENV['AUTH_NAME'], password: ENV['AUTH_PASS']
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:danger] = exception.message
    redirect_to new_user_session_path
  end

  private

    def after_sign_out_path_for(resource_or_scope)
      new_user_session_path
    end

    def after_sign_in_path_for(resource_or_scope)
      first_page = Site.first.pages.first
      if first_page
        edit_page_path id: first_page
      else
        new_site_page_path site_id: Site.first
      end
    end
end
