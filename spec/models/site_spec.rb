require 'spec_helper'

describe Site do

  it { should have_many(:pages).dependent(:destroy) }
  it { should belong_to(:user) }
  it do
    should ensure_inclusion_of(:language)
       .in_array(LanguageList::COMMON_LANGUAGES.map { |l| l.iso_639_1 })
  end

  describe '#import_json' do
    let(:user) { create :user }
    it 'can import a json' do
      pending
      # WebMock.should have_requested(:get, 'www.superjson.com')
      #   .with(body: File.new(Rails.root.join('spec', 'fixtures', 'site.json')))
      FakeWeb.register_uri(:get, "http://www.superjson.com/", response: File.read(Rails.root.join('spec', 'fixtures', 'site.json')))
      Site.import(user, 'http://www.superjson.com')
    end
  end
end
