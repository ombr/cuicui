class PagesController < ApplicationController
  def show
    @site = Site.find(params[:site_id])
    @page = @site.pages.find(params[:id])
    if @page.description.blank? && @page.images.count > 0
      return redirect_to site_page_image_path(page_id: @page, id: @page.images.first)
    end
    @description = @page.description_html.html_safe
  end

  def edit
    @site = Site.find(params[:site_id])
    @page = @site.pages.find(params[:id])
    render layout: 'admin'
  end

  def new
    @site = Site.find(params[:site_id])
    @page = Page.new
    render layout: 'admin'
  end

  def create
    @site = Site.find(params[:site_id])
    @page = @site.pages.create!(page_params)
    redirect_to edit_site_page_path(site_id: @site, id: @page)
  end

  def destroy
    @site = Site.find(params[:site_id])
    @page = @site.pages.find(params[:id])
    @page.destroy!
    redirect_to edit_site_path(id: @site)
  end

  def update
    @site = Site.find(params[:site_id])
    @page = @site.pages.find(params[:id])
    @page.update(page_params)
    redirect_to edit_site_page_path(site_id: @site, id: @page)
  end

  def page_params
    params.require(:page).permit(:name, :description)
  end
end
