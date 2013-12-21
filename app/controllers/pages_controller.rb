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

  def show
    if @page.description.blank? && @page.images.count > 0
      return redirect_to image_path(id: @page.images.first)
    end
    @description = @page.description_html.html_safe
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
