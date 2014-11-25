# ImageUploader
class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :fog

  if ENV['FOG_DOMAIN']
    def asset_host
      "http://#{ENV['FOG_DOMAIN']}"
    end
  end

  def filename
    if original_filename.present?
      if model && model.original.filename
        return "#{File.basename(model.original.filename).parameterize}#{File.extname(model.original.filename)}"
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
  process :extract_exifs
  version :full do
    process :optimize
    resize_to_limit(1920, 1400)
    process store_geometry: :full
  end

  version :social do
    resize_to_limit(1200, 630)
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
      geometries.merge!("#{version}" => "#{img['width']}x#{img['height']}")
      model.geometries = geometries
      img
    end
  end

  def extract_exifs
    manipulate! do |img|
      begin
        infos = EXIFR::JPEG.new(open(img.path))
        exifs = {}
        exifs = infos.to_hash
        exifs['gps'] = "#{infos.gps.latitude},#{infos.gps.longitude}" if infos.gps
        xmp = XMP.parse(infos)
        if xmp
          xmp.namespaces.each do |namespace_name|
            name = namespace_name
            exifs[name] = {}
            namespace = xmp.send(namespace_name)
            namespace.attributes.each do |attr|
              exifs[name][attr] = namespace.send(attr)
            end
          end
        end
        model.exifs = exifs
      rescue Exception => e
        puts e.inspect
        Raven.capture_exception(e)
      end
      img
    end
  end
end
