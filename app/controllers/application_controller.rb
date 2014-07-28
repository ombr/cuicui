# ApplicationController
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include RouteHelper
  protect_from_forgery with: :exception

  skip_after_filter :intercom_rails_auto_include

  rescue_from CanCan::AccessDenied do |exception|
    flash[:danger] = exception.message
    redirect_to new_user_session_path
  end

  def load_site_id_from_host
    params[:site_id] = request.subdomain if request.subdomain.present?
  end

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def record_not_found e
    return redirect_to new_site_url(
      site: {
        title: params[:site_id]
      },
      subdomain: ''
    ) if params[:site_id]
    raise e
  end

  private

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(_resource_or_scope)
    sites_path
  end
end
