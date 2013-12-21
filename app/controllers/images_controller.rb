class ImagesController < ApplicationController
  load_and_authorize_resource only: [:show, :move_higher, :move_lower, :destroy]
  load_and_authorize_resource :page,
                              through: :image,
                              singleton: true,
                              only: [
                                :show,
                                :move_higher,
                                :move_lower,
                                :destroy
                              ]
  load_and_authorize_resource :site, through: :page, singleton: true, only: [:show]

  load_and_authorize_resource :page, only: [:create]

  def create
    return redirect_to edit_page_path(id: @page), flash: { error: params[:error] } if params[:error]
    @image = @page.images.build
    path = "#{params[:resource_type]}/#{params[:type]}/v#{params[:version]}/#{params[:public_id]}"
    path += ".#{params[:format]}" if params[:format].present?
    path += "##{params[:signature]}"
    @image.image = path
    @image.exifs = Cloudinary::Api.resource(params[:public_id], exif: true)['exif']
    @image.save!
    redirect_to edit_page_path(id: @page)
  end

  def move_higher
    @image.move_higher
    redirect_to edit_page_path @page
  end

  def move_lower
    @image.move_lower
    redirect_to edit_page_path @page
  end

  def show
  end

  def destroy
    @image.destroy
    redirect_to edit_page_path @page
  end
end
