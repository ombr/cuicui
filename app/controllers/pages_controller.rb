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
end
