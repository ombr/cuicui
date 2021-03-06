require 'spec_helper'

describe 'layouts/_application_without_nav.html.haml' do

  it 'render font_body' do
    FakeWeb.register_uri(
      :get,
      "https://www.googleapis.com/webfonts/v1/webfonts?key=#{ENV['GOOGLE_FONT_KEY']}",
      body: File.read(
        Rails.root.join('spec', 'fixtures', 'google_webfonts.json')
      ),
      content_type: 'application/json'
    )
    assign(:site, create(:site, font_body: 'Lobster'))
    render
    Capybara.string(rendered).should have_content('Lobster')
  end

  it 'render font_header' do
    FakeWeb.register_uri(
      :get,
      "https://www.googleapis.com/webfonts/v1/webfonts?key=#{ENV['GOOGLE_FONT_KEY']}",
      body: File.read(
        Rails.root.join('spec', 'fixtures', 'google_webfonts.json')
      ),
      content_type: 'application/json'
    )
    assign(:site, create(:site, font_header: 'Open Sans'))
    render
    Capybara.string(rendered).should have_content('Open Sans')
  end

  it 'render google analytics' do
    site = create(:site, google_analytics_id: 'lalalal')
    assign(:site, site)
    render
    Capybara.string(rendered).should have_content(site.google_analytics_id)
  end
end
