# ImageController
class ImagesController < ApplicationController
  before_action :load_site_from_host, only: [:show]

  load_and_authorize_resource :site

  before_action :load_page, only: [:show]
  load_and_authorize_resource :page, through: :site
  before_action :redirect_if_page_slug_changed, only: [:show]

  load_and_authorize_resource through: :page

  def new
    respond_to do |format|
      format.json do
        @image.original.use_action_status = true
        @image.original.success_action_status = '201'
        render json: @image.original.params
      end
    end
  end

  def add
    @image = Image.new(page: @page)
    @uploader = @image.original.key = params[:key]
    @image.save
    flash[:error] = @image.errors.full_messages.to_sentence unless @image.save
    Resque.enqueue ImageConversion, @image.id
    analytics_track('Created Image', id: @image.id, position: @image.position,
                                     page: @page.id, site: @site.id)
    redirect_to edit_page_path(@page)
    @page.images.race_fix if @page.images.race_test
  end

  def create
    return redirect_to edit_page_path(@page),
                       flash: { error: params[:error] } if params[:error]
    @image = @page.images.build
    @image.image = cloudinary_path
    @image.save!
    @image.extract_exifs
    @images = @page.images
    # with cloudinary we need to force the format ;-(
    return render 'create.js' if request.xhr?
    redirect_to edit_page_path(@page)
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
    previous_position = @image.position
    @image.update!(image_params)
    if @image.position != previous_position
      redirect_to edit_page_path(@page)
    else
      redirect_to edit_image_path(@image)
    end
  end

  def destroy
    @image.update page: nil
    Resque.enqueue ObjectDeletion, 'Image', @image.id
    redirect_to edit_page_path @page
  end

  def image_params
    params.require(:image).permit(:legend,
                                  :title,
                                  :full,
                                  :content,
                                  :content_css,
                                  :image_css,
                                  :position,
                                  :focusx,
                                  :focusy)
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
