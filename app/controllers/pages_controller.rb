# PagesController
class PagesController < ApplicationController
  include HighVoltage::StaticPage
  layout :layout_for_page

  before_action :load_site_from_host_for_legal

  def load_site_from_host_for_legal
    return unless params[:id] == 'legal'
    load_site_from_host
  end

  def layout_for_page
    return 'application' if @site && params[:id] == 'legal'
    'admin'
  end

  rescue_from ActionView::MissingTemplate do |_exception|
    redirect_to root_path
  end
end
