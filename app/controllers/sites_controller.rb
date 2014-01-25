class SitesController < ApplicationController
  load_and_authorize_resource only: [:show, :edit, :update]

  def show
    @site = Site.find(params[:id])
    first_page = @site.pages.first
    redirect_to page_path(id: first_page) if first_page
  end

  def edit
    @site = Site.find(params[:id])
    render layout: 'admin'
  end

  def update
    @site = Site.find(params[:id])
    unless params[:site][:favicon].nil?
      Cloudinary::Uploader.upload(params[:site][:favicon], public_id: 'favicon', format: :ico)
      flash[:success] = I18n.t 'sites.favicon_updated'
    end
    @site.update(site_params)
    redirect_to edit_site_path(id: @site)
  end

  def robots
    @allow = false
    @allow = true if URI.parse("http://#{ENV['DOMAIN']}").host == request.host
    render layout: false
  end

  def site_params
    params.require(:site).permit(:name, :description, :css)
  end
end
