class ImageConversion
  @queue = :convert
  def self.perform image_id
    puts "PROCESS: #{image_id}"
    image = Image.find(image_id)
    image.process
  end
end
