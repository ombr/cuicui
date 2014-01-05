class ImagesController < ApplicationController
  load_and_authorize_resource only: [:show, :move_higher, :move_lower, :destroy, :edit, :update]
  load_and_authorize_resource :page,
                              through: :image,
                              singleton: true,
                              only: [
                                :show,
                                :move_higher,
                                :move_lower,
                                :destroy,
                                :edit,
                                :update
                              ]
  load_and_authorize_resource :site, through: :page, singleton: true, only: [:show, :edit]

  load_and_authorize_resource :page, only: [:create]

  def create
    if params[:error]
      return redirect_to edit_page_path(id: @page), flash: { error: params[:error] }
    end
    @image = @page.images.build
    path = "#{params[:resource_type]}/#{params[:type]}/v#{params[:version]}/#{params[:public_id]}"
    path += ".#{params[:format]}" if params[:format].present?
    path += "##{params[:signature]}"
    @image.image = path
    @image.save!
    @image.extract_exifs
    if request.xhr?
      render 'create.js' #with cloudinary we need to force the format ;-(
    else
      redirect_to edit_page_path(id: @page)
    end
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
    expires_in 5.minutes, public: true
  end

  def edit
    render layout: 'admin'
  end

  def update
    @image.update!(image_params)
    redirect_to edit_page_path(id: @page)
  end

  def destroy
    @image.destroy
    redirect_to edit_page_path @page
  end

  def image_params
    params.require(:image).permit(:description)
  end
end
