# SitesController
class SitesController < ApplicationController
  load_and_authorize_resource only: [:show, :edit, :update, :new, :create]

  def index
    @sites = current_user.sites
    render layout: 'admin'
  end

  def new
    render layout: 'admin'
  end

  def create
    @site.user = current_user
    if @site.save
      redirect_to new_site_page_path(site_id: @site)
    else
      render :new, layout: 'admin'
    end
  end

  def show
    @site = Site.find(params[:id])
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
    params.require(:site).permit(:title,
                                 :slug,
                                 :description,
                                 :css,
                                 :metas,
                                 :language,
                                 :twitter_id,
                                 :facebook_id,
                                 :facebook_app_id,
                                 :google_plus_id,
                                 :google_analytics_id)
  end
end
