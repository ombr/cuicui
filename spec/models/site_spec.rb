require 'spec_helper'

describe Site do

  it { should have_many(:pages) }
  it { should belong_to(:user) }
  it do
    should ensure_inclusion_of(:language)
       .in_array(LanguageList::COMMON_LANGUAGES.map { |l| l.iso_639_1 })
  end

  describe '#first' do
    it 'return a new site if there is no site' do
      Site.first.should_not be_nil
    end
  end
end
