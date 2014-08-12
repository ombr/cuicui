# ImageUploader
class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :fog

  def filename
    if original_filename.present?
      if model
        return "#{File.basename(model.original.filename).parameterize}.jpg"
      end
    end
    super
  end

  def default_url
    ActionController::Base.helpers.asset_path("/#{version_name}_default.png")
  end

  def store_dir
    if model
      "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      super
    end
  end

  process store_geometry: :original
  version :full do
    process :optimize
    resize_to_fit(1920, 1400)
    process store_geometry: :full
  end

  version :social do
    resize_to_fit(1200, 630)
    process store_geometry: :social
  end

  version :thumbnail do
    process :optimize
    resize_to_fill(250, 200, 'North')
  end

  version :icon do
    resize_to_fill(60, 60)
  end

  def optimize
    manipulate! do |img|
      return img unless img.mime_type.match(/image\/jpeg/)
      img.auto_orient
      img.strip
      img.combine_options do |c|
        c.quality '80'
        c.depth '8'
        c.interlace 'plane'
      end
      img
    end
  end

  def store_geometry(version)
    manipulate! do |img|
      geometries = model.geometries || {}
      geometries.merge!("#{version}"=> "#{img['width']}x#{img['height']}")
      model.geometries = geometries
      img
    end
  end
end
