# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  make_private
  eager

  version :thumbnail do
    resize_to_fill(200, 100)
  end

  version :full do
    cloudinary_transformation transformation: [
      { width: 1500, height: 1200, crop: :limit, quality: 80, flags: 'progressive' }
    ]
  end
end
