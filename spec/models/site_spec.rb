require 'spec_helper'

describe Site do

  it { should have_many(:pages).dependent(:destroy) }
  it { should belong_to(:user) }
  it do
    should ensure_inclusion_of(:language)
       .in_array(LanguageList::COMMON_LANGUAGES.map { |l| l.iso_639_1 })
  end

  describe 'domain resolution' do
    it 'returns nil when site not found' do
      expect(
        Site.find_by_host("super-test.#{ENV['DOMAIN']}")
      ).to be_nil
    end

    it 'returns nil when site not found' do
      expect(
        Site.find_by_host('luc.boissaye.fr')
      ).to be_nil
    end

    it 'resolve with custom domain' do
      site = create :site, title: 'lala', domain: 'luc.boissaye.fr'
      expect(
        Site.find_by_host('luc.boissaye.fr')
      ).to eq site
    end

    it 'resolve with subdomain with ENV[DOMAIN].' do
      create :site, title: 'lala'
      site = create :site, title: 'super test'
      expect(
        Site.find_by_host("super-test.#{ENV['DOMAIN']}")
      ).to eq site
    end

    it 'returns nil for ENV[DOMAIN]' do
      expect(
        Site.find_by_host(ENV['DOMAIN'])
      ).to be_nil
    end
  end

  describe '#import_json' do
    let(:user) { create :user }
    it 'can import a json' do
      pending
      # WebMock.should have_requested(:get, 'www.superjson.com')
      #   .with(body: File.new(
      #   Rails.root.join('spec', 'fixtures', 'site.json'))
      #   )
      FakeWeb.register_uri(:get,
                           'http://www.superjson.com/',
                           response: File.read(
                             Rails.root.join('spec', 'fixtures', 'site.json')
                           ))
      Site.import(user, 'http://www.superjson.com')
    end
  end
end
