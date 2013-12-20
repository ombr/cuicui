class ImagesController < ApplicationController
  load_and_authorize_resource only: [:show]
  load_and_authorize_resource :page, through: :image, singleton: true, only: [:show]
  load_and_authorize_resource :site, through: :page, singleton: true, only: [:show]

  load_and_authorize_resource :page, only: [:create]

  def create
    @image = @page.images.build
    path = "#{params[:resource_type]}/#{params[:type]}/v#{params[:version]}/#{params[:public_id]}"
    path += ".#{params[:format]}" if params[:format].present?
    path += "##{params[:signature]}"
    @image.image = path
    @image.exifs = Cloudinary::Api.resource(params[:public_id], exif: true)['exif']
    @image.save!
    redirect_to edit_page_path(site_id: @site, id: @page)
  end

  def show
  end
end
