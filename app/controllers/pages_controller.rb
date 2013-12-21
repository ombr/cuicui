class PagesController < ApplicationController
  load_and_authorize_resource only: [
    :edit,
    :show,
    :destroy,
    :update,
    :move_higher,
    :move_lower
  ]
  load_and_authorize_resource :site,
                              through: :page,
                              singleton: true,
                              only: [:edit, :show, :destroy, :update]
  load_and_authorize_resource :site, only: [:new, :create]

  def index
    @site = Site.first
    return redirect_to new_user_session_path if @site.nil?
    @page = @site.pages.first
    return redirect_to new_user_session_path if @page.nil?
    if @page.description.blank? && @page.images.count > 0
      return redirect_to image_path(id: @page.images.first)
    end
    render :show
  end

  def show
    if @page.description.blank? && @page.images.count > 0
      return redirect_to image_path(id: @page.images.first)
    end
  end

  def edit
    render layout: 'admin'
  end

  def new
    @page = @site.pages.build
    render layout: 'admin'
  end

  def create
    @page = @site.pages.create! page_params
    redirect_to edit_page_path(id: @page)
  end

  def destroy
    @page.destroy!
    redirect_to edit_site_path(id: @site)
  end

  def update
    @page.update(page_params)
    redirect_to edit_page_path(@page)
  end

  def move_higher
    @page.move_higher
    redirect_to edit_page_path @page
  end

  def move_lower
    @page.move_lower
    redirect_to edit_page_path @page
  end

  def page_params
    params.require(:page).permit(:name, :description)
  end
end
