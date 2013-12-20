class Image < ActiveRecord::Base
  serialize :exifs
  belongs_to :page
  acts_as_list scope: :page
  mount_uploader :image, ImageUploader

  def description
    return exifs['ImageDescription'] if exifs && exifs['ImageDescription']
    nil
  end

  def self.reindex
    Page.to_a.each do |page|
      i = 0
      page.images.each do |image|
        image.update(position: i)
        i += 1
      end
    end
  end
end
