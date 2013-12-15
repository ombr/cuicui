class WelcomeController < ApplicationController
  def index
    @site = Site.first
    if @site
      redirect_to site_path(id: @site)
    else
      @site = Site.create!
      redirect_to edit_site_path(id: @site)
    end
  end
end
