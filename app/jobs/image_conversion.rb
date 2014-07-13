# ImageConversion
class ImageConversion
  require 'heroku_resque_auto_scale.rb'
  extend HerokuAutoScaler::AutoScaling if Rails.env.production?

  @queue = :convert
  def self.perform(image_id)
    puts "PROCESS: #{image_id}"
    image = Image.find(image_id)
    image.process
  end
end
