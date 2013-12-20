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

    it 'change the css' do
      expect do
        put :update, id: site, site: { css: 'test' }
      end.to change { site.reload.css }.to('test')
    end

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

    context 'without page' do
      before :each do
        get :show, id: site
      end

      it_responds_200

      it 'assigns @site' do
        assigns(:site).should == site
      end
    end

    context 'with one page' do
      it 'redirect to first_page if defined' do
        page = FactoryGirl.create :page, site: site
        get :show, id: site
        response.should redirect_to page_path(id: page)
      end
    end

  end
end
