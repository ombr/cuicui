require 'spec_helper'

describe SitesController do
  let(:site) { FactoryGirl.create :site }
  let(:user) { FactoryGirl.create :user }

  describe '#robots' do
    render_views
    it 'respond 200' do
      get :robots
    end
  end

  describe '#sitemap' do
    render_views

    it 'respond 200' do
      get :sitemap
      response.code.should == '200'
    end

    it 'assigns @urls' do
      get :sitemap
      assigns(:urls).class.should == Array
    end

    it '@urls include images url' do
      create :image
      get :sitemap
      urls = Image.all.map { |i| s_image_url(page_id: i.page, id: i) }
      (urls - assigns(:urls).map { |u| u[:loc] }).length.should == 0
    end
  end

  describe '#edit' do
    before :each do
      sign_in user
      get :edit, id: site
    end

    it { response.code.should == '200' }
    it('assigns @site') { assigns(:site).should == site }
    it('render layout admin') { response.should render_template(:admin) }
  end

  describe '#update' do

    it 'update the favicon' do
      Cloudinary::Uploader.should_receive(:upload)
        .with('FAVICON_FILE', public_id: 'favicon', format: :ico)
      sign_in user
      put :update, id: site, site: { favicon: 'FAVICON_FILE' }
      flash[:success].should == I18n.t('sites.favicon_updated')
    end

    it 'change the css' do
      expect do
        sign_in user
        put :update, id: site, site: { css: 'test' }
      end.to change { site.reload.css }.to('test')
    end

    it 'change the name' do
      expect do
        sign_in user
        put :update, id: site, site: { name: 'test' }
      end.to change { site.reload.name }.to('test')
    end

    it 'change the description' do
      expect do
        sign_in user
        put :update, id: site, site: { description: 'test' }
      end.to change { site.reload.description }.to('test')
    end

    it 'redirect to edit' do
      sign_in user
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
