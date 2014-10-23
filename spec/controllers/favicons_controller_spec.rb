require 'spec_helper'

describe FaviconsController do
  describe '#show' do
    it 'redirect_to favicon' do
      site = create :site
      @request.host = "#{site.slug}.#{ENV['DOMAIN']}"
      get :show, all: '.ico'
      response.should redirect_to site.favicon.url('ico')
    end

    it 'redirect_to favicon 16' do
      site = create :site
      @request.host = "#{site.slug}.#{ENV['DOMAIN']}"
      get :show, all: '-16x16.png'
      response.should redirect_to site.favicon.url('thumb16')
    end
  end
end
