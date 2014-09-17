# UsersController
class UsersController < ApplicationController
  layout 'admin'

  def show
    @sites = current_user.sites
    redirect_to new_site_path if @sites.empty?
  end
end
