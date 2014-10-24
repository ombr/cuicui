# ImageConversion
class ImageConversion
  # require 'heroku_resque_auto_scale.rb'
  # extend HerokuAutoScaler::AutoScaling if Rails.env.production?

  @queue = :convert
  def self.perform(image_id)
    image = Image.find_by_id(image_id)
    image.process if image
  end
end
