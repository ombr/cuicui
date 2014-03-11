require 'spec_helper'

describe PagesController do

  let(:page) { FactoryGirl.create :page, site: site }
  let(:site) { Site.first }
  let(:user) { FactoryGirl.create :user }

  describe '#index' do
    render_views
    it 'redirect to login if there is no site' do
      get :index
      response.should redirect_to new_user_session_path
    end

    it 'redirect to login if there is no page for the site' do
      site
      get :index
      response.should redirect_to new_user_session_path
    end

    context 'without description and image' do
      let(:image) { FactoryGirl.create :image, page: page }
      let(:page) { FactoryGirl.create :page, description: '', site: site }
      render_views
      before :each do
        image
        get :index
      end

      it_responds_200
    end

    it 'assigns page' do
      page
      get :index
      assigns(:page).should == page
    end

    it 'assigns site' do
      site
      get :index
      assigns(:site).should == site
    end

    it 'respond 200 when there is a page' do
      page
      get :index
      response.code.should == '200'
    end

  end
  describe '#show' do
    render_views
    context 'default' do
      before :each do
        get :show, site_id: page.site, id: page
      end
      it_responds_200
      it('assigns @site') { assigns(:site).should == page.site }
      it('assigns @page') { assigns(:page).should == page }
    end

    context 'without description and image' do
      let(:image) { FactoryGirl.create :image, page: page }
      let(:page) { FactoryGirl.create :page, description: '', site: site }
      it_responds_200
    end
  end

  describe '#edit' do
    render_views
    before :each do
      sign_in user
      create :image, page: page
      get :edit, site_id: page.site, id: page
    end
    it_responds_200
    it('assigns @site') { assigns(:site).should == page.site }
    it('assigns @page') { assigns(:page).should == page }
    it('render layout admin') { response.should render_template(:admin) }
  end

  describe '#new' do
    render_views
    before :each do
      get :new, site_id: page.site
    end
    it_responds_200
    it('assigns @site') { assigns(:site).should == page.site }
    it('assigns @page') { assigns(:page).class.should == Page }
  end

  describe '#preview' do
    render_views
    before :each do
      sign_in user
      get :preview, id: page
    end
    it_responds_200
    it('assigns @page') { assigns(:page).should == page }
  end

  describe '#create' do
    it 'render new with an empty name' do
      sign_in user
      post :create, site_id: site, page: { name: '' }
      response.should render_template :new
      response.should render_template 'admin'
    end

    it 'create a new page' do
      expect do
        sign_in user
        post :create, site_id: site, page: { name: 'test' }
      end.to change { Page.count }.by(1)
    end

    it 'redirect to edit' do
      sign_in user
      post :create, site_id: site, page: { name: 'test' }
      response.should redirect_to edit_page_path(id: Page.first)
    end

  end

  describe '#delete' do

    it('delete the page') do
      page
      expect do
        sign_in user
        delete :destroy, id: page
      end.to change { Page.count }.by(-1)
    end

    it 'redirect to edit site' do
      sign_in user
      delete :destroy, id: page
      response.should redirect_to new_site_page_path(site_id: page.site)
    end

  end

  describe '#update' do

    context 'when update the position' do
      it 'update the position using insert_at' do
        Page.any_instance.should_receive(:insert_at).with(2)
        sign_in user
        put :update, id: page, page: { position: 2 }
      end

      it 'redirect to edit page' do
        sign_in user
        put :update, id: page, page: { position: 2 }
        response.should redirect_to edit_page_path(id: page)
      end
    end

    it('update the name') do
      expect do
        sign_in user
        put :update, id: page, page: { name: 'test' }
      end.to change { page.reload.name }.to 'test'
    end

    it 'update the theme' do
      expect do
        sign_in user
        put :update, id: page, page: { theme: 'dark' }
      end.to change { page.reload.theme }.to 'dark'
    end

    it('update the description_html') do
      expect do
        sign_in user
        put :update, id: page, page: { description_html: 'test' }
      end.to change { page.reload.description_html }.to 'test'
    end

    it('update the description') do
      expect do
        sign_in user
        put :update, id: page, page: { description: 'test' }
      end.to change { page.reload.description }.to 'test'
    end

    it 'redirect to edit' do
      sign_in user
      put :update, id: page, page: { name: 'test' }
      response.should redirect_to edit_page_path(id: page.reload)
    end

    it 'redirect to preview if sended with preview' do
      sign_in user
      put :update, id: page, page: { name: 'test' }, preview: 'Update and preview'
      response.should redirect_to preview_page_path(id: page.reload)
    end

    it 'flash a message' do
      sign_in user
      put :update, id: page, page: { name: 'test' }
      flash[:success].should == I18n.t('pages.update.success')
    end
  end
end
