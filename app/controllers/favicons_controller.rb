# FaviconsController
class FaviconsController < ApplicationController
  before_filter :load_site_from_host, only: [:show]

  def show
    @site ||= Site.new
    filename = File.basename(URI(request.original_url).path)
    size = filename[/\d+(?:\.\d+)?/].to_i
    if FaviconUploader.sizes.include? size
      favicon = @site.favicon.url("thumb#{size}")
    else
      favicon = @site.favicon.url('thumb16')
    end
    favicon = @site.favicon.url('ico') if File.extname(filename) == '.ico'
    redirect_to favicon, status: :moved_permanently
  end
end
