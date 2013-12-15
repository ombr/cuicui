class SitesController < ApplicationController
  def show
    @site = Site.find(params[:id])
  end

  def edit
    @site = Site.find(params[:id])
  end

  def update
    @site = Site.find(params[:id])
    @site.update(site_params)
    redirect_to edit_site_path(id: @site)
  end

  def site_params
    params.require(:site).permit(:name)
  end
end
