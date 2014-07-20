# Site
class Site < ActiveRecord::Base
  belongs_to :user
  has_many :pages, -> { order('position') }, dependent: :destroy
  has_many :images, through: :pages
  LANGUAGES = LanguageList::COMMON_LANGUAGES.map { |l| l.iso_639_1 }
  validates_inclusion_of :language,
                         in: LANGUAGES
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders, :history]

  def should_generate_new_friendly_id?
    title_changed?
  end

  def slug_candidates
    [
      :title,
      [:title, I18n.l(Date.today)],
      [:title, I18n.l(Time.zone.now)]
    ]
  end

  class << self
    def first
      super || Site.create!
    end
  end
end
