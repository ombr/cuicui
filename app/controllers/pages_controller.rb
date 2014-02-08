class PagesController < ApplicationController
  load_and_authorize_resource only: [
    :edit,
    :show,
    :destroy,
    :update,
    :move_higher,
    :move_lower
  ]
  load_and_authorize_resource :site,
                              through: :page,
                              singleton: true,
                              only: [:edit, :show, :destroy, :update]
  load_and_authorize_resource :site, only: [:new, :create]

  def index
    @site = Site.first
    return redirect_to new_user_session_path if @site.nil?
    @page = @site.pages.first
    return redirect_to new_user_session_path if @page.nil?
    @image = @page.images.first if @page.images.first
    expires_in 5.minutes, public: true if Rails.env.production?
    render :show
  end

  def show
    if @page.description.blank? && @page.images.count > 0
      return redirect_to s_image_path(page_id: @page, id: @page.images.first)
    end
    @image = @page.images.first if @page.images.first
    expires_in 5.minutes, public: true if Rails.env.production?
  end

  def edit
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
    redirect_to edit_page_path(@page)
  end

  def move_higher
    @page.move_higher
    redirect_to edit_page_path @page
  end

  def move_lower
    @page.move_lower
    redirect_to edit_page_path @page
  end

  def page_params
    params.require(:page).permit(:name, :description, :description_html)
  end
end
