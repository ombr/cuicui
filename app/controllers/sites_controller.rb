class SitesController < ApplicationController
  def show
    @site = Site.find(params[:id])
    md = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      autolink: true,
      space_after_headers: true
    )
    @description = md.render(@site.description).html_safe
  end

  def edit
    @site = Site.find(params[:id])
  end

  def update
    @site = Site.find(params[:id])
    @site.update(site_params)
    redirect_to edit_site_path(id: @site)
  end

  def site_params
    params.require(:site).permit(:name, :description)
  end
end
