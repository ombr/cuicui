# ImageController
class ImagesController < ApplicationController
  load_and_authorize_resource only: [:show, :destroy, :edit, :update]
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
  load_and_authorize_resource :site,
                              through: :page,
                              singleton: true,
                              only: [:show, :edit]

  load_and_authorize_resource :page, only: [:create]

  def create
    return redirect_to edit_page_path(id: @page),
                       flash: { error: params[:error] } if params[:error]
    @image = @page.images.build
    @image.image = cloudinary_path
    @image.save!
    @image.extract_exifs
    @images = @page.images
    # with cloudinary we need to force the format ;-(
    return render 'create.js' if request.xhr?
    redirect_to edit_page_path(id: @page)
  end

  def show
    # expires_in 5.minutes, public: true if Rails.env.production?
    if stale? [@site, @page, @image]
      if request.xhr?
        render layout: false
      else
        render 'pages/show'
      end
    end
  end

  def edit
    render layout: 'admin'
  end

  def update
    @image.update!(image_params)
    if params[:image] && params[:image][:position]
      @image.insert_at(params[:image][:position].to_i)
      @image.save!
      return redirect_to edit_page_path(id: @image.page)
    end
    redirect_to edit_image_path(id: @image)
  end

  def destroy
    @image.destroy
    redirect_to edit_page_path @page
  end

  def image_params
    params.require(:image).permit(:legend,
                                  :title,
                                  :full,
                                  :content,
                                  :content_css)
  end

  private

  def cloudinary_path
    path = "#{params[:resource_type]}/#{params[:type]}"
    path += "/v#{params[:version]}/#{params[:public_id]}"
    path += ".#{params[:format]}" if params[:format].present?
    path += "##{params[:signature]}"
    path
  end
end
