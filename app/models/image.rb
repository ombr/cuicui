class Image < ActiveRecord::Base
  serialize :exifs
  belongs_to :page
  acts_as_list scope: :page
  mount_uploader :image, ImageUploader

  def description
    return self[:description] if self[:description]
    return exifs['ImageDescription'] if exifs && exifs['ImageDescription']
    nil
  end

  def extract_exifs
    self[:exifs] = Cloudinary::Api.resource(
      image.file.public_id,
      type: :private,
      exif: true
      )['exif']
    save!
  end

  def self.reindex
    Page.all.each do |page|
      i = 1
      page.images.each do |image|
        image.update(position: i)
        i += 1
      end
    end
  end

  def to_param
    if description
      "#{id}-#{description.parameterize[0..60]}"
    else
      id.to_s
    end
  end
end
