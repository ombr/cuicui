# PagesController
class PagesController < ApplicationController
  load_and_authorize_resource only: [
    :edit,
    :show,
    :destroy,
    :update,
    :preview,
    :next,
    :index,
    :new,
    :create
  ]
  load_and_authorize_resource :site,
                              through: :page,
                              singleton: true,
                              only: [:edit, :show, :destroy, :update, :next]
  load_and_authorize_resource :site, only: [:new, :create]

  def index
    @site = load_site_from_host
  end

  def first
    @site = load_site_from_host
    return redirect_to new_user_session_path if @site.nil?
    @page = @site.pages.first
    return redirect_to new_user_session_path if @page.nil?
    @image = @page.images.first if @page.images.first
    render :show
  end

  def show
    # if @page.description.blank? && @page.images.count > 0
      # return redirect_to s_image_path(page_id: @page, id: @page.images.first)
    # end
    @image = @page.images.first if @page.images.first
    # expires_in 5.minutes, public: true if Rails.env.production?
  end

  def preview
    render layout: 'admin'
  end

  def next
  end

  def edit
    @image = Image.new page: @page
    @image.original.success_action_redirect = add_page_images_url(page_id: @page)
    render layout: 'admin'
  end

  def new
    @page = @site.pages.build
    render layout: 'admin'
  end

  def create
    @page = @site.pages.build page_params
    if @page.save
      return redirect_to edit_page_path(id: @page)
    else
      return render :new, layout: 'admin'
    end
  end

  def destroy
    @page.destroy!
    redirect_to new_site_page_path(site_id: @site)
  end

  def update
    @page.update(page_params)
    if params[:page] && params[:page][:position]
      @page.insert_at(params[:page][:position].to_i)
      @page.save!
      return redirect_to edit_page_path(id: @page)
    end
    return redirect_to preview_page_path(@page) if params[:preview]
    flash[:success] = t('.success')
    redirect_to edit_page_path(@page)
  end

  def page_params
    params.require(:page).permit(:name,
                                 :description,
                                 :description_html,
                                 :theme)
  end
end
