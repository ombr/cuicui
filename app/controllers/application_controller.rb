# ApplicationController
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include RouteHelper
  protect_from_forgery with: :exception

  before_action :set_locale
  skip_after_filter :intercom_rails_auto_include

  rescue_from CanCan::AccessDenied do |exception|
    flash[:danger] = exception.message
    redirect_to new_user_session_path
  end

  def load_site_id_from_host
    if request.subdomain.present? && !user_signed_in?
      params[:site_id] = request.subdomain
    end
  end

  def set_locale
    I18n.locale =
      params[:locale] || request.env['rack.locale'] || I18n.default_locale
  end

  def default_url_options(options = {})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { locale: I18n.locale }
  end

  private

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(_resource_or_scope)
    edit_user_registration_path
  end
end
