class ImagesController < ApplicationController
  def create
    @site = Site.find(params[:site_id])
    @page = @site.pages.find(params[:page_id])
    @image = @page.images.build
    @image.image = params[:image_id]
    @image.save!
    @image.update exifs: Cloudinary::Api.resource(@image.image.file.public_id, exif: true)['exif']
    redirect_to edit_site_page_path(site_id: @site, id: @page)
  end
end
