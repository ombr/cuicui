require 'spec_helper'

describe PagesController do

  let(:page) { FactoryGirl.create :page }
  let(:site) { FactoryGirl.create :site }
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
      it('redirect_to_first_image') do
        image
        get :show, site_id: page.site, id: page
        response.should redirect_to s_image_path(page_id: page, id: page.images.first)
      end
    end
  end

  describe '#edit' do
    before :each do
      sign_in user
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
      response.should redirect_to edit_site_path(id: page.site)
    end

  end

  describe '#update' do
    it('update the name') do
      expect do
        sign_in user
        put :update, id: page, page: { name: 'test' }
      end.to change { page.reload.name }.to 'test'
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
  end

  context 'ordering' do
    before :each do
      sign_in user
    end

    let(:page2) { FactoryGirl.create :page, site: page.site }
    let(:page3) { FactoryGirl.create :page, site: page.site }

    describe '#move_higer' do

      it 'change position' do
        expect do
          put :move_higher, id: page2
        end.to change { page2.reload.position }.by(-1)
      end

      it 'redirect to edit_page' do
        put :move_higher, id: page
        response.should redirect_to edit_page_path page
      end
    end

    describe '#move_lower' do

      it 'change position' do
        page
        page2
        page3
        expect do
          put :move_lower, id: page2
        end.to change { page2.reload.position }.by(1)
      end

      it 'redirect to edit_page' do
        put :move_lower, id: page
        response.should redirect_to edit_page_path page
      end
    end
  end

end
