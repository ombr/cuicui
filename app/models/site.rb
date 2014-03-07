class Site < ActiveRecord::Base
  has_many :pages, -> { order('position') }
  validates_inclusion_of :language, in: LanguageList::COMMON_LANGUAGES.map{|l| l.iso_639_1}

  class << self
    def first
      super || Site.create!
    end
  end
end
