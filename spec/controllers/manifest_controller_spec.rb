require 'spec_helper'

describe ManifestController do
  let(:site) { create :site, user: user }
  let(:user) { create :user }

  describe '#show' do

    before :each do
      @request.host = "#{site.slug}.#{ENV['DOMAIN']}"
    end
    render_views

    it 'respond 200' do
      get :show, type: :basic, format: 'text'
      response.code.should == '200'
    end
  end
end
