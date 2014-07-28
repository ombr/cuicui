# HomeController
class HomeController < ApplicationController
  include HighVoltage::StaticPage
  layout 'admin'

  def show
    params[:id] ||= 'home'
  end
end
