require 'spec_helper'

describe SitesController do
  let(:site) { create :site, user: user }
  let(:user) { create :user }

  describe '#robots' do
    render_views
    it 'respond 200' do
      get :robots
    end
  end

  describe '#sitemap' do
    before :each do
      @request.host = "#{site.slug}.#{ENV['DOMAIN']}"
    end
    render_views

    it 'respond 200' do
      get :sitemap
      expect(response.code).to eq '200'
    end

    it 'assigns @urls' do
      get :sitemap
      assigns(:urls).class.should eq Array
      assigns(:urls).length.should eq site.images.count
    end

    it '@urls include images url' do
      page = create :page, site: site
      create :image, page: page
      get :sitemap
      urls = Image.all.map { |i| s_image_url(page_id: i.page, id: i) }
      (urls - assigns(:urls).map { |u| u[:loc] }).length.should == 0
    end

    it 'render sitemap' do
      get :sitemap
      expect(response).to render_template 'sitemap'
    end

    context 'for registration website' do
      before :each do
        @request.host = "www.#{ENV['DOMAIN']}"
      end

      it 'respond 200' do
        get :sitemap
        expect(response.code).to eq '200'
      end

      it 'render sitemap_root' do
        get :sitemap
        expect(response).to render_template 'sitemap_root'
      end
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

    it 'update the font_body' do
      sign_in user
      FakeWeb.register_uri(
        :get,
        "https://www.googleapis.com/webfonts/v1/webfonts?key=#{ENV['GOOGLE_FONT_KEY']}",
        body: File.read(
          Rails.root.join('spec', 'fixtures', 'google_webfonts.json')
        ),
        content_type: 'application/json'
      )
      expect do
        sign_in user
        put :update, id: site, site: { font_header: '', font_body: 'Open Sans' }
      end.to change { site.reload.font_body }.to('Open Sans')
    end

    it 'update the font_header' do
      sign_in user
      FakeWeb.register_uri(
        :get,
        "https://www.googleapis.com/webfonts/v1/webfonts?key=#{ENV['GOOGLE_FONT_KEY']}",
        body: File.read(
          Rails.root.join('spec', 'fixtures', 'google_webfonts.json')
        ),
        content_type: 'application/json'
      )
      expect do
        sign_in user
        put :update, id: site, site: { font_header: 'Open Sans' }
      end.to change { site.reload.font_header }.to('Open Sans')
    end

    it 'update the language' do
      sign_in user
      expect do
        sign_in user
        put :update, id: site, site: { language: 'fr' }
      end.to change { site.reload.language }.to('fr')
    end

    it 'update the domain' do
      sign_in user
      expect do
        sign_in user
        put :update, id: site, site: { domain: 'luc.boissaye.fr' }
      end.to change { site.reload.domain }.to('luc.boissaye.fr')
    end

    it 'change the css' do
      expect do
        sign_in user
        put :update, id: site, site: { css: 'test' }
      end.to change { site.reload.css }.to('test')
    end

    it 'change the metas' do
      expect do
        sign_in user
        put :update, id: site, site: { metas: 'test' }
      end.to change { site.reload.metas }.to('test')
    end

    it 'change the twitter_id' do
      expect do
        sign_in user
        put :update, id: site, site: { twitter_id: '@ombr' }
      end.to change { site.reload.twitter_id }.to('@ombr')
    end

    it 'change the facebook_id' do
      expect do
        sign_in user
        put :update, id: site, site: { facebook_id: 'ombr' }
      end.to change { site.reload.facebook_id }.to('ombr')
    end

    it 'change the facebook_id' do
      expect do
        sign_in user
        put :update, id: site, site: { facebook_app_id: 'ombr' }
      end.to change { site.reload.facebook_app_id }.to('ombr')
    end

    it 'change the google_id' do
      expect do
        sign_in user
        put :update, id: site, site: { google_plus_id: 'ombr' }
      end.to change { site.reload.google_plus_id }.to('ombr')
    end

    it 'change the title' do
      expect do
        sign_in user
        put :update, id: site, site: { title: 'test' }
      end.to change { site.reload.title }.to('test')
    end

    it 'change the description' do
      expect do
        sign_in user
        put :update, id: site, site: { description: 'test' }
      end.to change { site.reload.description }.to('test')
    end

    it 'change the google analytics id' do
      expect do
        sign_in user
        put :update, id: site, site: { google_analytics_id: 'UA-576110360' }
      end.to change { site.reload.google_analytics_id }.to('UA-576110360')
    end

    it 'redirect to edit' do
      sign_in user
      put :update, id: site, site: { description: 'test' }
      response.should redirect_to edit_site_path(id: site)
    end

    it 'flash a message' do
      sign_in user
      put :update, id: site, site: { title: 'test' }
      flash[:success].should == I18n.t('sites.update.success')
    end

  end

  describe '#new' do
    before :each do
      sign_in user
      get :new
    end

    it { response.code.should == '200' }
    it('assigns @site') { assigns(:site).class.should eq Site }
    it('render layout admin') { response.should render_template(:admin) }
  end

  describe '#create' do
    it 'create a new site for the user' do
      sign_in user
      expect do
        post :create, site: { title: 'My Amazing site' }
      end.to change { Site.count }.by(1)
      Site.last.user.should == user
    end

    it 'create a first page' do
      sign_in user
      post :create, site: { title: 'My Amazing site' }
      expect(user.sites.last.pages.first.name).to eq(
        I18n.t('sites.create.first_page')
      )
    end

    it 'redirects to the page creation' do
      sign_in user
      post :create, site: { title: 'My Amazing site' }
      response.should redirect_to edit_site_page_path(
        site_id: Site.last,
        id: Page.last
      )
    end
  end

  describe '#index' do
    context 'with a site' do
      let(:site) { create :site, user: user }
      before :each do
        sign_in user
        create :site, user: nil
        site
        get :index
      end

      it { response.code.should == '200' }
      it('assigns @sites') { assigns(:sites).should == [site] }
      it('render layout admin') { response.should render_template(:admin) }
    end

    context 'without a site' do
      it 'redirect to site#new' do
        sign_in user
        get :index
        response.should redirect_to new_site_path
      end
    end
  end

  describe '#show' do

    it 'redirect to DOMAIN when REDIRECT_HOST' do
      old_domain = ENV['REDIRECT_DOMAIN'].split(',').first
      @request.host = "hello-world.#{old_domain}"
      get :show, id: 'test'
      expect(response).to redirect_to host: "hello-world.#{ENV['DOMAIN']}"
    end

    context 'without page' do
      before :each do
        get :show, id: site
      end

      it_responds_200

      it 'assigns @site' do
        assigns(:site).should == site
      end
    end

    context 'when site changed name' do
      it 'redirect to new domain' do
        site = create :site, title: 'hello world'
        site.update title: 'super new world'
        @request.host = "hello-world.#{ENV['DOMAIN']}"
        get :show, id: site
        expect(response).to redirect_to host: "super-new-world.#{ENV['DOMAIN']}"
      end
    end
  end

  describe '#destroy' do

    it 'delete the site' do
      site
      expect do
        sign_in user
        delete :destroy, id: site
      end.to change { Site.count }.by(-1)
    end

    it 'redirect to user_path' do
      sign_in user
      delete :destroy, id: site
      response.should redirect_to user_path(id: user)
    end
  end
end
