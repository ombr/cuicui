# Image
class Image < ActiveRecord::Base
  serialize :exifs
  belongs_to :page, touch: true
  has_one :site, through: :page

  acts_as_list scope: :page
  mount_uploader :cloudinary, CloudinaryUploader

  mount_uploader :original, FileUploader
  mount_uploader :image, ImageUploader
  validates :original, is_uploaded: true

  def url(version)
    return image.url version if image?
    return cloudinary.url version if cloudinary?
    original.url
  end

  def process
    self.image = open(original.url)
    save!
  end

  def legend
    return self[:legend] if self[:legend]
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

  def content_rendered
    md = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      autolink: true,
      space_after_headers: true
    )
    md.render(content || '')
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

  def self.cleanup
    Image.find_each { |i| i.destroy if i.page.nil? }
  end

  def priority
    total = page.images.count
    (total - position + 1).to_f / (total).to_f
  end

  def seo_title
    return title unless title.blank?
    return content unless content.blank?
    return legend unless legend.blank?
    "#{site.title} : #{page.name}"
  end

  def seo_description
    return content unless content.blank?
    legend
  end

  def to_param
    if legend
      "#{id}-#{legend.parameterize[0..60]}"
    else
      id.to_s
    end
  end
end
