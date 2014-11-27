class ManifestController < ApplicationController
  before_action :load_site_from_host

  def show
    @assets = %w(application.css application-dark.css application-light.css
                 application.js)
    %w(eot ttf svg woff).each do |ext|
      @assets << "entypo.#{ext}"
    end
    @sections = ['/']
    @site.sections.each do |section|
      @sections << section_path(section)
      if section.images.first
        @sections << image_path(section.images.first)
        @sections << section.images.first.url(:full)
      end
    end
    render :show, format: :text, content_type: 'text/cache-manifest'
  end
end
