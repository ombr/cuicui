# SitesController
class SitesController < ApplicationController
  before_action :load_site_from_host, only: [:show, :sitemap, :robots]
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
      analytics_track('Created Site', id: @site.id, name: @site.title)
      @page = @site.pages.create name: I18n.t('sites.create.first_page')
      redirect_to edit_site_page_path(site_id: @site, id: @page)
    else
      render :new, layout: 'admin'
    end
  end

  def show
    @site = Site.find(params[:id])
    respond_to do |format|
      format.html
      format.json do
        return render json: @site, include: {
          pages: {
            include: {
              images: { methods: [:original_url] }
            }
          }
        }
      end
    end
  end

  def edit
    @site = Site.find(params[:id])
    render layout: 'admin'
  end

  def update
    @site = Site.find(params[:id])
    @site.update!(site_params)
    flash[:success] = I18n.t('sites.update.success')
    redirect_to edit_site_path(id: @site)
  end

  def robots
    @allow = true
    render layout: false
  end

  def sitemap
    return render 'sitemap_root',
                  layout: false,
                  formats: [:xml] if request_root?
    @urls = sitemap_urls
    render layout: false, formats: [:xml]
  end

  def request_root?
    request.host == "www.#{ENV['DOMAIN']}"
  end

  def sitemap_urls
    @site.pages.each_with_object([]) do |page, urls|
      page.images.each do |image|
        urls << {
          loc: s_image_url(page_id: page, id: image),
          changefreq: :weekly,
          priority: image.priority
        }
      end
    end
  end

  def destroy
    @site.update user: nil
    Resque.enqueue ObjectDeletion, 'Site', @site.id
    redirect_to user_path(id: current_user)
  end

  def site_params
    params.require(:site).permit(:title, :slug, :description, :css, :metas,
                                 :language, :twitter_id, :facebook_id,
                                 :facebook_app_id, :google_plus_id,
                                 :google_analytics_id, :domain, :font_header,
                                 :font_body)
  end
end
