require 'spec_helper'

describe Site do

  it { should have_many(:pages).dependent(:destroy) }
  it { should belong_to(:user) }
  it do
    should ensure_inclusion_of(:language)
       .in_array(LanguageList::COMMON_LANGUAGES.map { |l| l.iso_639_1 })
  end
end
