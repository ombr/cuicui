# ImageExifs
class ImageExifs
  require 'heroku_resque_auto_scale.rb'
  extend HerokuAutoScaler::AutoScaling if Rails.env.production?

  @queue = :exifs
  def self.perform(image_id)
    image = Image.find_by_id(image_id)
    image.extract_exifs if image
  end
end
