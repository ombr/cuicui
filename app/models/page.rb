# Page
class Page < ActiveRecord::Base
  validates :name, presence: true
  validates :theme, inclusion: { in: %w(light dark) }
  belongs_to :site, touch: true
  has_one :user, through: :site

  has_many :images, -> { order('position') }, dependent: :destroy
  acts_as_list scope: :site

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders, :history, :scoped], scope: :site

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
      site.pages.each do |page|
        page.update(position: i)
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

  private

  def slug_candidates
    [
      :name,
      [:name, I18n.l(Date.today)],
      [:name, I18n.l(Time.zone.now)]
    ]
  end
end
