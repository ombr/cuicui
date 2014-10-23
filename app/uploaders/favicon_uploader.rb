# FaviconUploader
class FaviconUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def self.sizes
    [192, 160, 96, 16, 32, 57, 114, 72, 144, 60, 120, 76, 152, 180]
  end

  storage :fog

  def default_url
    ActionController::Base.helpers.asset_path("/#{version_name}_default.png")
  end

  def filename
    if original_filename.present?
      return "#{model.title.parameterize}.png" if model && model.title?
    end
    "#{super}.png"
  end

  def store_dir
    if model
      "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      super
    end
  end

  process :center_and_square
  resize_to_fill(260, 260)

  sizes.each do |size|
    version :"thumb#{size}" do
      resize_to_fill(size, size)
    end
  end

  version :ico do
    def full_filename(_for_file = model.logo.file)
      'favicon.ico'
    end
    process convert: 'ico'
    resize_to_fill(16, 16)
  end

  def center_and_square
    manipulate! do |img|
      img.format('png', 1)
      cols, rows = img[:dimensions]
      size = img[:dimensions].min
      image = model.pages.first.images.first
      if rows != cols
        if image.focusx? && image.focusy?
          img.combine_options do |cmd|
            x = (image.focusx * cols / 100 - size / 2).round
            x = cols - size if x + size > cols
            x = 0 if x < 0
            y = (image.focusy * rows / 100 - size / 2).round
            y = rows - size if y + size > rows
            y = 0 if y < 0
            cmd.crop "#{size}x#{size}+#{x}+#{y}"
            cmd.repage.+
          end
        end
      end
      img = yield(img) if block_given?
      img
    end
  end
end
