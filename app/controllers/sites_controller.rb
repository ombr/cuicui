class SitesController < ApplicationController
  def show
    @site = Site.find(params[:id])
    first_page = @site.pages.first
    redirect_to site_page_path(site_id: @site, id: first_page) if first_page
  end

  def edit
    @site = Site.find(params[:id])
    render layout: 'admin'
  end

  def update
    @site = Site.find(params[:id])
    @site.update(site_params)
    redirect_to edit_site_path(id: @site)
  end

  def site_params
    params.require(:site).permit(:name, :description)
  end
end
