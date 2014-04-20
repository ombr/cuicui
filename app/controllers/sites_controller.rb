# SitesController
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
      Cloudinary::Uploader.upload(params[:site][:favicon],
                                  public_id: 'favicon',
                                  format: :ico)
      flash[:success] = I18n.t 'sites.favicon_updated'
    end
    @site.update(site_params)
    flash[:success] = I18n.t('sites.update.success')
    redirect_to edit_site_path(id: @site)
  end

  def robots
    @allow = false
    @allow = true if URI.parse("http://#{ENV['DOMAIN']}").host == request.host
    render layout: false
  end

  def sitemap
    @urls = []
    Image.order(:position).each do |i|
      @urls << {
        loc: s_image_url(page_id: i.page, id: i),
        changefreq: :weekly,
        priority: i.priority
      }
    end
    render layout: false, formats: [:xml]
  end

  def site_params
    params.require(:site).permit(:title, :description, :css, :metas, :language)
  end
end
