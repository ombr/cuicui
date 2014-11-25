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

  after_save :favicon_changed?, on: [:create, :update]

  def url(version = :original)
    return download_url if version == :original
    return image.url version if image?
    download_url
  end

  def download_url
    return Rails.cache.fetch([self, 'original-url'], expires_in: 1.hour) do
      original.url
    end if original?
    image.url
  end

  def processed?
    image?
  end

  def process
    LocalFile.process(download_url) do |file|
      self.image = file
      save!
    end
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

  def content_text
    return '' unless content?
    Nokogiri::HTML(content_rendered).text
  end

  def content_string
    content_text.gsub("\n", ' ')
  end

  def seo_title
    if title? or content? or legend?
      "#{title} #{content_string} #{legend}"
    else
      page.name
    end
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

  def favicon_changed?
    return unless first? && page && page.first?
    Resque.enqueue FaviconGeneration, site.id if focusx_changed? ||
                                                 focusy_changed? ||
                                                 position_changed?
  end

  class << self
    def race_fix
      connection.update(
        "UPDATE images SET position = ranked.rank FROM (#{ranked_sql}) AS ranked WHERE images.id = ranked.id",
        'Image Update'
      )
    end

    def race_test
      select('position').group('position').having('COUNT(position) > 1').any?
    end

    def ranked_sql
      connection.unprepared_statement do
        ranked.to_sql
      end
    end

    def ranked
      select('id, rank() OVER (ORDER BY position, created_at) AS rank')
    end
  end
end
