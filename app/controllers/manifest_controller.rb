class ManifestController < ApplicationController
  before_action :load_site_from_host

  def offline?
    cookies[:offline] == 'true'
  end

  def show
    return render(text: 'Disabled', status: 404) unless offline?
    @urls = site_urls + assets_urls
    render :show, format: :text, content_type: 'text/cache-manifest'
  end

  def site_urls
    @site.sections.each_with_object(default_pages) do |section, urls|
      section.images.each_with_object(urls) do |image, links|
        links << s_image_path(id: image, section_id: section)
        links << image.url(:full)
      end
      urls << s_section_path(id: section)
    end
  end

  def default_pages
    %w( / /sections /pages/legal http://sdasdsad.sadas.com/)
  end

  def assets_urls
    links = %w(application.css application-dark.css application-light.css
               application.js).each_with_object([]) do |assets, urls|
      urls << asset_path(assets)
    end
    %w(eot ttf svg woff).each_with_object(links) do |ext, urls|
      urls << asset_path("entypo.#{ext}")
    end
  end

  def asset_path(asset)
    ActionController::Base.helpers.asset_path asset
  end
end
