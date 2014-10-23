# FaviconGeneration
class FaviconGeneration
  @queue = :favicon
  def self.perform(site_id)
    return if Rails.env.test?
    Site.find_by_id(site_id).favicon_process
  end
end
