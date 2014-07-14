# Page
class Page < ActiveRecord::Base
  validates :name, presence: true
  validates :theme, inclusion: { in: %w(light dark) }
  belongs_to :site, touch: true
  has_one :user, through: :site

  has_many :images, -> { order('position') }
  acts_as_list scope: :site

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders, :history, :scoped], scope: :site

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
end
