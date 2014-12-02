# Section
class Section < ActiveRecord::Base
  scope :not_empty, -> { joins(:images).distinct }

  validates :name, presence: true,
                   length: { in: 3..30 },
                   uniqueness: { case_sensitive: false, scope: :site }
  validates :theme, inclusion: { in: %w(light dark) }
  belongs_to :site, touch: true
  has_one :user, through: :site

  has_many :images, -> { order('position') }, dependent: :destroy
  after_save :favicon_changed?, on: :update
  acts_as_list scope: :site

  extend FriendlyId
  friendly_id :slug_candidates,
              use: [:slugged, :finders, :history, :scoped],
              scope: :site

  after_validation :move_friendly_id_error_to_name
  def move_friendly_id_error_to_name
    errors.add(:name,
               *errors.delete(:friendly_id)
              ) if errors[:friendly_id].present?
  end

  def should_generate_new_friendly_id?
    name_changed?
  end

  def description_rendered
    md = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      autolink: true,
      space_after_headers: true
    )
    md.render(description || '')
  end

  def self.reindex
    Site.all.each do |site|
      i = 1
      site.sections.each do |section|
        section.update(position: i)
        i += 1
      end
    end
  end

  def json_import(json)
    %w( name description position description_html theme ).each do |field|
      value = json[field.to_s]
      self[field] = value if value
    end
  end

  def favicon_changed?
    Resque.enqueue(FaviconGeneration, site.id) if first? && position_changed?
  end

  private

  def slug_candidates
    [
      :name,
      [:name, I18n.l(Date.today)],
      [:name, I18n.l(Time.zone.now)]
    ]
  end
end
