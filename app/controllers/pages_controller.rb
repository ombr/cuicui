# PagesController
class PagesController < ApplicationController
  before_action :load_site_from_host, only: [:show, :first, :index]
  load_and_authorize_resource :site

  before_action :autoload_if_no_ids, only: [:show]
  before_action :load_page, only: [:show, :edit]
  before_action :redirect_if_page_slug_changed, only: [:show, :edit]
  load_and_authorize_resource through: :site

  def autoload_if_no_ids
    @page = @site.pages.first if params[:id].blank?
  end

  def load_page
    @page = @site.pages.friendly.find(params[:id]) if params[:id]
  end

  def redirect_if_page_slug_changed
    redirect_to id: @page if params[:id] && @page.slug != params[:id]
  end

  def index
    @pages = @site.pages.not_empty
    @pages_count = @pages.count
    return redirect_to root_path if @pages_count < 2
  end

  def show
    @image = @page.images.first if @page.images.first
  end

  def preview
    render layout: 'admin'
  end

  def next
  end

  def edit
    @image = Image.new page: @page
    @image.original.success_action_redirect = add_images_url(@page)
    render layout: 'admin'
  end

  def new
    @page = @site.pages.build
    render layout: 'admin'
  end

  def create
    @page = @site.pages.build page_params
    if @page.save
      analytics_track('Created Page',
                      id: @page.id,
                      name: @page.name,
                      site: @site.id)
      return redirect_to edit_page_path(@page)
    else
      return render :new, layout: 'admin'
    end
  end

  def destroy
    @page.update site: nil
    Resque.enqueue ObjectDeletion, 'Page', @page.id
    redirect_to edit_site_path(id: @site)
  end

  def update
    previous_position = @page.position
    @page.update(page_params)
    flash[:success] = t('.success')
    if @page.position != previous_position
      redirect_to my_edit_site_path(@site)
    else
      redirect_to edit_page_path(@page)
    end
  end

  def page_params
    params.require(:page).permit(:name,
                                 :position,
                                 :description,
                                 :description_html,
                                 :theme)
  end
end
