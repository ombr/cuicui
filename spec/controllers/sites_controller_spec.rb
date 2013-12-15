require 'spec_helper'

describe SitesController do
  let(:site) { FactoryGirl.create :site }

  describe 'show' do
    it 'respond 200' do
      get :show, id: site
      response.code.should == '200'
    end

    it 'assigns @site' do
      get :show, id: site
      assigns(:site).should == site
    end
  end
end
