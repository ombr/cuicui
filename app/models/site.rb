# Site
class Site < ActiveRecord::Base
  belongs_to :user
  has_many :sections, -> { order('position') }, dependent: :destroy
  has_many :images, through: :sections

  LANGUAGES = LanguageList::COMMON_LANGUAGES.map(&:iso_639_1)
  validates :language, inclusion: LANGUAGES
  validates_with FontFamilyValidator,
                 fields: [:font_header, :font_body],
                 allow_nil: true
  validates :title, presence: true,
                    length: { in: 3..30 },
                    uniqueness: { case_sensitive: false }

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders, :history]

  mount_uploader :favicon, FaviconUploader

  def should_generate_new_friendly_id?
    title_changed?
  end

  def self.import(user, url)
    site = json_import(JSON.parse(HTTParty.get(url).body))
    site.user = user
    site.save
  end

  def favicon_process
    return unless sections.first && sections.first.images.first
    LocalFile.process(sections.first.images.first.url(:full)) do |file|
      self.favicon = file
      save!
    end
  end

  def self.json_import(json)
    site = Site.new
    site.json_import(json)
    site.save!
    json['sections'].each do |json_section|
      section = site.sections.new
      section.json_import(json_section)
      section.save!
      json_section['images'].each do |json_image|
        image = section.images.new
        image.json_import(json_image)
        image.save!
      end
    end
    site
  end

  def self.find_by_host(host)
    custom_site = find_by_domain(host)
    return custom_site if custom_site
    match = Regexp.new("^(.*)\.#{ENV['DOMAIN']}$").match(host)
    return find(match[1]) if match
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def host
    if domain.present?
      domain
    else
      "#{slug}.#{ENV['DOMAIN']}"
    end
  end

  def json_import(json)
    %w( title description css metas language twitter_id facebook_id
        facebook_app_id google_plus_id google_analytics_id).each do |field|
      value = json[field.to_s]
      self[field] = value if value
    end
  end
end
