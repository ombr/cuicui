# SitesController
class SitesController < ApplicationController
  before_filter :load_site_id_from_host, only: [:show, :sitemap, :robots]
  load_and_authorize_resource

  before_action :authenticate_user!, only: [:index]
  def index
    @sites = current_user.sites
    if @sites.count > 0
      render layout: 'admin'
    else
      redirect_to new_site_path
    end
  end

  def new
    render layout: 'admin'
  end

  def create
    @site.user = current_user
    if @site.save
      redirect_to edit_site_path(id: @site)
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

  def destroy
    @site.update user: nil
    Resque.enqueue ObjectDeletion, 'Site', @site.id
    redirect_to edit_user_registration_path
  end

  def site_params
    params.require(:site).permit(:title, :slug, :description, :css, :metas,
                                 :language, :twitter_id, :facebook_id,
                                 :facebook_app_id, :google_plus_id,
                                 :google_analytics_id)
  end
end
