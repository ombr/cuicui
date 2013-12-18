# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  version :thumbnail do
    resize_to_fit(50, 50)
  end

  version :full do
    cloudinary_transformation :transformation => [
      {width: 1200, height: 1200, crop: :limit, quality: 80, flags: 'progressive'}
    ]
  end
end
