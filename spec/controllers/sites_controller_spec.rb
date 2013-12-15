require 'spec_helper'

describe SitesController do
  describe 'show' do
    it 'respond 200' do
      FactoryGirl.create :site
      get :show, id: Site.first
      response.code.should == '200'
    end
  end
end
