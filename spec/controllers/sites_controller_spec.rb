require 'spec_helper'

describe SitesController do
  let(:site) { FactoryGirl.create :site }

  describe '#edit' do
    before :each do
      get :edit, id: site
    end

    it { response.code.should == '200' }
    it('assigns @site') { assigns(:site).should == site }
  end
  describe '#update' do
    it 'change the name' do
      expect do
        put :update, id: site, site: { name: 'test' }
      end.to change { site.reload.name }.to('test')
    end

    it 'change the description' do
      expect do
        put :update, id: site, site: { description: 'test' }
      end.to change { site.reload.description }.to('test')
    end

    it 'redirect to edit' do
      put :update, id: site, site: { name: 'test' }
      response.should redirect_to edit_site_path(id: site)
    end

  end

  describe '#show' do
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
