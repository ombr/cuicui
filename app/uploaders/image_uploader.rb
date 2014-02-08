# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  make_private
  eager

  process convert: 'jpg'

  version :thumbnail do
    resize_to_fill(200, 150)
    eager
  end

  version :full do
    eager
    cloudinary_transformation transformation: [
      { width: 1920, height: 1400, crop: :limit, quality: 80, flags: 'progressive' }
    ]
  end
end
