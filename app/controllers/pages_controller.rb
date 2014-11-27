# PagesController
class PagesController < ApplicationController
  include HighVoltage::StaticPage
  layout 'admin'

  rescue_from ActionView::MissingTemplate do |_exception|
    redirect_to root_path
  end
end
