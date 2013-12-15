class PagesController < ApplicationController
  def show
    @site = Site.find(params[:site_id])
    @page = @site.pages.find(params[:id])
    md = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      autolink: true,
      space_after_headers: true
    )
    @description = md.render(@page.description || '').html_safe
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
