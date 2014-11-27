# PagesController
class PagesController < ApplicationController
  include HighVoltage::StaticPage
  layout 'admin'
end
