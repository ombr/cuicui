# SectionsController
class SectionsController < ApplicationController
  before_action :load_site_from_host, only: [:show, :first, :index]
  load_and_authorize_resource :site

  before_action :autoload_if_no_ids, only: [:show]
  before_action :load_section, only: [:show, :edit]
  before_action :redirect_if_section_slug_changed, only: [:show, :edit]
  load_and_authorize_resource through: :site
  before_action :init_image, only: [:edit, :update]

  def autoload_if_no_ids
    @section = @site.sections.first if params[:id].blank?
  end

  def load_section
    @section = @site.sections.friendly.find(params[:id]) if params[:id]
  end

  def redirect_if_section_slug_changed
    redirect_to id: @section if params[:id] && @section.slug != params[:id]
  end

  def index
    @sections = @site.sections.not_empty
    @sections_count = @sections.count
    return redirect_to root_path if @sections_count < 2
  end

  def show
    @image = @section.images.first if @section.images.first
  end

  def preview
    render layout: 'admin'
  end

  def next
  end

  def edit
    render layout: 'admin'
  end

  def new
    @section = @site.sections.build
    render layout: 'admin'
  end

  def create
    @section = @site.sections.build section_params
    if @section.save
      analytics_track('Created Section',
                      id: @section.id,
                      name: @section.name,
                      site: @site.id)
      return redirect_to edit_section_path(@section)
    else
      return render :new, layout: 'admin'
    end
  end

  def destroy
    @section.update site: nil
    Resque.enqueue ObjectDeletion, 'Section', @section.id
    redirect_to edit_site_path(id: @site)
  end

  def update
    previous_position = @section.position
    if @section.update(section_params)
      flash[:success] = t('.success')
      if @section.position != previous_position
        redirect_to my_edit_site_path(@site)
      else
        redirect_to edit_section_path(@section)
      end
    else
      render :edit, layout: 'admin'
    end
  end

  def init_image
    @image = Image.new section: @section
    @image.original.success_action_redirect = add_images_url(@section)
  end

  def section_params
    params.require(:section).permit(:name,
                                    :position,
                                    :description,
                                    :description_html,
                                    :theme)
  end
end
