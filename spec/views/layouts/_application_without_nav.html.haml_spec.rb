require 'spec_helper'

describe 'layouts/_application_without_nav.html.haml' do
  let(:site) { create :site, google_analytics_id: 'lalalal' }
  it 'render' do
    assign(:site, site)
    render
    Capybara.string(rendered).should have_content(site.google_analytics_id)
  end
end
