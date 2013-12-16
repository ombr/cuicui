class ImagesController < ApplicationController
  def create
    @site = Site.find(params[:site_id])
    @page = @site.pages.find(params[:page_id])
    @image = @page.images.build
    path = "#{params[:resource_type]}/#{params[:type]}/v#{params[:version]}/#{params[:public_id]}"
    path += ".#{params[:format]}" if params[:format].present?
    path += "##{params[:signature]}"
    @image.image = path
    @image.exifs = Cloudinary::Api.resource(params[:public_id], exif: true)['exif']
    @image.save!
    redirect_to edit_site_page_path(site_id: @site, id: @page)
  end
end
