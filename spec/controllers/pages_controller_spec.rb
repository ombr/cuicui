require 'spec_helper'

describe PagesController do

  let(:page) { FactoryGirl.create :page }
  let(:site) { FactoryGirl.create :site }

  describe '#show' do
    render_views
    context 'default' do
      before :each do
        get :show, site_id: page.site, id: page
      end
      it_responds_200
      it('assigns @site') { assigns(:site).should == page.site }
      it('assigns @page') { assigns(:page).should == page }
      it('assigns @description') { assigns(:description).should == "<h3>Super description</h3>\n" }
    end

    context 'without and image' do
      let(:image) { FactoryGirl.create :image, page: page }
      let(:page) { FactoryGirl.create :page, description: '', site: site }
      it('redirect_to_first_image') do
        image
        get :show, site_id: page.site, id: page
        response.should redirect_to page.images.first
      end
    end
  end

  describe '#edit' do
    before :each do
      get :edit, site_id: page.site, id: page
    end
    it_responds_200
    it('assigns @site') { assigns(:site).should == page.site }
    it('assigns @page') { assigns(:page).should == page }
    it('render layout admin') { response.should render_template(:admin) }
  end

  describe '#new' do
    before :each do
      get :new, site_id: page.site
    end
    it_responds_200
    it('assigns @site') { assigns(:site).should == page.site }
    it('assigns @page') { assigns(:page).class.should == Page }
  end

  describe '#create' do

    it('create a new page') do
      expect do
        post :create, site_id: site, page: { name: 'test' }
      end.to change { Page.count }.by(1)
    end

    it 'redirect to edit' do
      post :create, site_id: site, page: { name: 'test' }
      response.should redirect_to edit_page_path(id: Page.first)
    end

  end

  describe '#delete' do

    it('delete the page') do
      page
      expect do
        delete :destroy, id: page
      end.to change { Page.count }.by(-1)
    end

    it 'redirect to edit site' do
      delete :destroy, id: page
      response.should redirect_to edit_site_path(id: page.site)
    end

  end

  describe '#update' do
    it('update the name') do
      expect do
        put :update, id: page, page: { name: 'test' }
      end.to change { page.reload.name }.to 'test'
    end

    it('update the description') do
      expect do
        put :update, id: page, page: { description: 'test' }
      end.to change { page.reload.description }.to 'test'
    end

    it 'redirect to edit' do
      put :update, id: page, page: { name: 'test' }
      response.should redirect_to edit_page_path(id: page.reload)
    end

  end

end
