# ImageController
class ImagesController < ApplicationController
  load_and_authorize_resource only: [:show, :destroy, :edit, :update, :create]
  load_and_authorize_resource :page,
                              through: :image,
                              singleton: true,
                              only: [
                                :show,
                                :move_higher,
                                :move_lower,
                                :destroy,
                                :edit,
                                :update,
                                :create
                              ]
  load_and_authorize_resource :site,
                              through: :page,
                              singleton: true,
                              only: [:show, :edit]

  load_and_authorize_resource :page, only: [:create, :new, :add]

  def new
    @image = Image.new page: @page
    respond_to do |format|
      format.html do
        @image.original.success_action_redirect = add_page_images_url(page_id: @page)
        render layout: 'admin'
      end
      format.json do
        @image.original.use_action_status = true
        @image.original.success_action_status = '201'
        render json: @image.original.params
      end
    end
  end

  def add
    @image = Image.new(page: @page)
    @uploader = @image.original
    @uploader.key = params[:key]
    @image.save
    flash[:error] = @image.errors.full_messages.to_sentence unless @image.save
    Resque.enqueue ImageConversion, @image.id
    redirect_to edit_page_path(id: @page)
  end

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
    stale?([@site, @page, @image])do
      render 'pages/show'
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
                                  :content_css,
                                  :image_css)
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
