require 'spec_helper'

describe SitesController do
  let(:site) { FactoryGirl.create :site }

  describe '#edit' do
    before :each do
      get :edit, id: site
    end

    it { response.code.should == '200' }
    it('assigns @site') { assigns(:site).should == site }
    it('render layout admin') { response.should render_template(:admin) }
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

    it 'redirect to first_page if defined' do
      page = FactoryGirl.create :page, site: site
      get :show, id: site
      response.should redirect_to site_page_path(site_id: site, id: page)
    end

    it 'assigns @site' do
      get :show, id: site
      assigns(:site).should == site
    end
  end
end
