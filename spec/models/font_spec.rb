require 'spec_helper'

describe Font do

  before :each do
    FakeWeb.register_uri(
      :get,
      "https://www.googleapis.com/webfonts/v1/webfonts?key=#{ENV['GOOGLE_FONT_KEY']}",
      body: File.read(
        Rails.root.join('spec', 'fixtures', 'google_webfonts.json')
      ),
      content_type: 'application/json'
    )
  end

  describe '#all' do
    it 'return all fonts' do
      expect(Font.all.count).to eq 674
    end
  end

  describe '#families' do
    it 'returns Open Sans' do
      expect(Font.families).to include 'Open Sans'
    end
  end
end
