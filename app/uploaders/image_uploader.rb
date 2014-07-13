# ImageUploader
class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :fog

  process convert: :jpg

  def filename
    if original_filename.present?
      if model
        return "#{File.basename(model.original.filename).parameterize}.jpg"
      end
    end
    super
  end

  def store_dir
    if model
      "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      super
    end
  end

  version :full do
    process :optimize
    resize_to_fit(1920, 1400)
  end

  version :social do
    resize_to_fit(1200, 630)
  end

  version :thumbnail do
    process :optimize
    resize_to_fill(250, 200, 'North')
  end

  version :icon do
    resize_to_fit(80, 40)
  end

  def optimize
    manipulate! do |img|
      return img unless img.mime_type.match(/image\/jpeg/)
      img.strip
      img.combine_options do |c|
        c.quality '80'
        c.depth '8'
        c.interlace 'plane'
      end
      img
    end
  end
end
