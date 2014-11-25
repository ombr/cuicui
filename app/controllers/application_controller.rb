# ApplicationController
require 'analytics.rb'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include RouteHelper
  include Analytics
  protect_from_forgery with: :exception

  before_action :redirect_domains
  before_action :set_locale
  skip_after_filter :intercom_rails_auto_include

  rescue_from ActiveRecord::RecordNotFound do |exception|
    if @page
      redirect_to page_url(@page) if @page
    else
      if @site
        redirect_to site_url(@site) if @site
      else
        fail exception
      end
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:danger] = exception.message
    redirect_to new_user_session_path
  end

  def redirect_domains
    return unless ENV['REDIRECT_DOMAIN']
    domains = ENV['REDIRECT_DOMAIN'].split(',')
    redirect_to domain: ENV['DOMAIN'] if domains.include? request.domain
  end

  def load_site_from_host
    @site = Site.find_by_host(request.host)
    redirect_to host: @site.host if @site && @site.host != request.host
  end

  def load_page
    @page = @site.pages.friendly.find(params[:page_id])
  end

  def redirect_if_page_slug_changed
    redirect_to page_id: @page if @page.slug != params[:page_id]
  end

  def set_locale
    I18n.locale = http_accept_language.compatible_language_from(
      I18n.available_locales
    )
    I18n.locale =
      params[:locale] if I18n.available_locales.include?(
        params[:locale].try(:to_sym)
    )
  end

  def default_url_options(options = {})
    if params[:locale].present?
      options.merge(locale: params[:locale])
    else
      {}
    end
  end

  private

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    user_path(id: resource_or_scope)
  end
end
