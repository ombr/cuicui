class WelcomeController < ApplicationController
  def index
    @site = Site.first
    if current_user
      redirect_to edit_site_path(id: Site.first || Site.create!)
    else
      return redirect_to new_user_session_path unless @site
      redirect_to site_path(id: @site)
    end
  end
end
