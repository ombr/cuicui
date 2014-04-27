# Site
class Site < ActiveRecord::Base
  has_many :pages, -> { order('position') }
  LANGUAGES = LanguageList::COMMON_LANGUAGES.map { |l| l.iso_639_1 }
  validates_inclusion_of :language,
                         in: LANGUAGES

  class << self
    def first
      super || Site.create!
    end
  end
end
