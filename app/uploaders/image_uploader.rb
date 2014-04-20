# encoding: utf-8
# ImageUploader
class ImageUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  make_private
  eager

  process convert: 'jpg'

  version :thumbnail do
    resize_to_fill(250, 200)
    eager
  end
  version :icon do
    resize_to_fit(80, 40)
    eager
  end
  version :social do
    resize_to_fit(1200, 630)
    eager
  end

  version :full do
    eager
    cloudinary_transformation transformation: [
      { width: 1920,
        height: 1400,
        crop: :limit,
        quality: 80,
        flags: 'progressive' }
    ]
  end
end
