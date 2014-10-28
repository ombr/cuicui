# Site
class Site < ActiveRecord::Base
  belongs_to :user
  has_many :pages, -> { order('position') }, dependent: :destroy
  has_many :images, through: :pages

  LANGUAGES = LanguageList::COMMON_LANGUAGES.map { |l| l.iso_639_1 }
  validates_inclusion_of :language, in: LANGUAGES
  validates_inclusion_of :font_header, in: (Font.families + [nil])
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
    return unless pages.first && pages.first.images.first
    self.favicon = open(pages.first.images.first.url(:full))
    save!
  end

  def self.json_import(json)
    site = Site.new
    site.json_import(json)
    site.save!
    json['pages'].each do |json_page|
      page = site.pages.new
      page.json_import(json_page)
      page.save!
      json_page['images'].each do |json_image|
        image = page.images.new
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

  def json_import(json)
    %w( title description css metas language twitter_id facebook_id
        facebook_app_id google_plus_id google_analytics_id).each do |field|
      value = json[field.to_s]
      self[field] = value if value
    end
  end
end
