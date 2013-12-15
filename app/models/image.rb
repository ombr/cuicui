class Image < ActiveRecord::Base
  serialize :exifs
  belongs_to :page
  mount_uploader :image, ImageUploader

  def description
    return exifs['ImageDescription'] if exifs && exifs['ImageDescription']
    nil
  end
end
