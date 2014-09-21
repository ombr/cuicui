# Image
class Image < ActiveRecord::Base
  has_one :site, through: :page
  belongs_to :page, touch: true
  has_one :user, through: :site

  acts_as_list scope: :page
  mount_uploader :cloudinary, CloudinaryUploader

  mount_uploader :original, FileUploader
  mount_uploader :image, ImageUploader
  mount_uploader :snapshot, ImageUploader

  validates :original, is_uploaded: true

  def url(version)
    return image.url version if image?
    return cloudinary.url version if cloudinary?
    Rails.cache.fetch([self, 'original-url'], expires_in: 1.hour) do
      original.url
    end
  end

  def processed?
    image?
  end

  def process
    self.image = open(original.url)
    save!
  end

  def snapshot!
    # return snapshot.url(version) if snapshot? && [:thumbnail, :icon].include?(version)
    Tempfile.open(['snapshot', '.png'], Rails.root.join('tmp'), encoding: 'ascii-8bit') do |file|
      Phantomjs.run(
        Rails.root.join('lib', 'rasterize.js').to_s,
        Rails.application.routes.url_helpers.site_page_image_url(site_id: site, page_id: page, id: id),
        file.path,
        '1920px*1080px',
        '1'
      )
      self.snapshot = file
      self.save!
    end
  end

  before_save do
    if legend.nil? && defined?(exifs['image_description'])
      self.legend = exifs['image_description']
    end
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

  def import_from_url(url)
    file = Tempfile.new(['import', '.jpg'],
                        Rails.root.join('tmp'),
                        encoding: 'ascii-8bit')
    begin
      file.write(URI.parse(url).read)
      self.image = file
      self.save!
    ensure
      file.close
      file.unlink
    end
  end

  def json_import(json)
    %w( position legend full content content_css title image_css
        focusx focusy ).each do |field|
      value = json[field.to_s]
      self[field] = value if value
    end
    import_from_url(json['original_url']) if json['original_url']
  end

  def original_url
    Cloudinary::Utils.private_download_url(image.file.public_id, :jpg).inspect
  end
end
