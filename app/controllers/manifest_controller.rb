class ManifestController < ApplicationController
  before_action :load_site_from_host

  def show
    @assets = %w(application.css application-dark.css application-light.css
                 application.js)
    %w(eot ttf svg woff).each do |ext|
      @assets << "entypo.#{ext}"
    end
    @pages = ['/']
    @site.pages.each do |page|
      @pages << page_path(page)
      if page.images.first
        @pages << image_path(page.images.first)
        @pages << page.images.first.url(:full)
      end
    end
    render :show, format: :text, content_type: 'text/cache-manifest'
  end
end
