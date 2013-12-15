class WelcomeController < ApplicationController
  def index
    redirect_to site_path(id: Site.first)
  end
end
