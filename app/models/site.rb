# Site
class Site < ActiveRecord::Base
  belongs_to :user
  has_many :pages, -> { order('position') }, dependent: :destroy
  has_many :images, through: :pages

  LANGUAGES = LanguageList::COMMON_LANGUAGES.map { |l| l.iso_639_1 }
  validates_inclusion_of :language, in: LANGUAGES
  validates :title, presence: true, length: { in: 3..30 }, uniqueness: { case_sensitive: false }

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders, :history]

  def should_generate_new_friendly_id?
    title_changed?
  end

end
