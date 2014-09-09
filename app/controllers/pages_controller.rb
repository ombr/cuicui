# PagesController
class PagesController < ApplicationController
  before_filter :load_site_id_from_host, only: [:show, :first, :index]

  load_and_authorize_resource :site
  load_and_authorize_resource through: :site

  before_action :autoload_if_no_ids, only: [:show]

  def autoload_if_no_ids
    @page = @site.pages.first if params[:id].blank?
  end

  def index
    @pages = @site.pages.joins(:images)
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
      return redirect_to edit_page_path(@page)
    else
      return render :new, layout: 'admin'
    end
  end

  def destroy
    @page.update site: nil
    Resque.enqueue ObjectDeletion, 'Page', @page.id
    redirect_to new_site_page_path(site_id: @site)
  end

  def update
    @page.update(page_params)
    if params[:page] && params[:page][:position]
      @page.insert_at(params[:page][:position].to_i)
      @page.save!
      return redirect_to edit_page_path(@page)
    end
    flash[:success] = t('.success')
    redirect_to edit_page_path(@page)
  end

  def page_params
    params.require(:page).permit(:name,
                                 :description,
                                 :description_html,
                                 :theme)
  end
end
