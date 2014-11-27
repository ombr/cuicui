require 'spec_helper'

describe SectionsController do
  include RouteHelper

  let(:user) { create :user }
  let(:site) { create :site, user: user }
  let(:section) { create :section, site: site }
  let(:image) { create :image, section: section }

  describe '#index' do

    context 'with 2 sections with images' do
      before :each do
        image
        create :image, section: create(:section, site: site)
        get :index, site_id: site
      end
      it_responds_200

      it('assigns site') { expect(assigns(:site)).to eq site }
      it 'assigns sections' do
        expect(assigns(:sections).to_a).to eq site.sections.to_a
      end
    end

    context 'with one empty section' do
      it 'redirects to root_path' do
        section
        get :index, site_id: site
        expect(response).to redirect_to root_path
      end
    end

    context 'without section' do
      it 'redirects to root_path' do
        get :index, site_id: site
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#next' do
    render_views
    context 'default' do
      before :each do
        get :next, site_id: site, id: section
      end
      it_responds_200
      it('assigns @site') { assigns(:site).should == section.site }
      it('assigns @section') { assigns(:section).should == section }
    end
  end

  describe '#show' do
    render_views
    context 'default' do
      before :each do
        get :show, site_id: section.site, id: section
      end
      it_responds_200
      it('assigns @site') { assigns(:site).should == section.site }
      it('assigns @section') { assigns(:section).should == section }
    end

    context 'without ids' do
      it 'respond 200' do
        @request.host = "#{section.site.slug}.#{ENV['DOMAIN']}"
        section
        get :show
        response.code.should == '200'
      end
    end

    context 'without description and image' do
      let(:image) { create :image, section: section }
      let(:section) { create :section, description: '', site: site }
      it_responds_200
    end

    it 'redirect when the section name changed' do
      @request.host = "#{section.site.slug}.#{ENV['DOMAIN']}"
      previous_slug = section.slug
      section.update(name: 'Super new name')
      get :show, id: previous_slug
      expect(response).to redirect_to id: 'super-new-name'
    end

    it 'redirects to root_path when section not found' do
      @request.host = "#{section.site.slug}.#{ENV['DOMAIN']}"
      section
      get :show, id: 'asdasdasd'
      expect(response).to redirect_to root_path
    end
  end

  describe '#edit' do
    render_views
    before :each do
      sign_in user
      create :image, section: section
      get :edit, site_id: site, id: section
    end
    it_responds_200
    it('assigns @site') { assigns(:site).should == section.site }
    it('assigns @section') { assigns(:section).should == section }
    it('render layout admin') { response.should render_template(:admin) }
  end

  describe '#new' do
    render_views
    before :each do
      sign_in user
      get :new, site_id: site
    end
    it_responds_200
    it('assigns @site') { assigns(:site).should == site }
    it('assigns @section') { assigns(:section).class.should == Section }
    it('assigns @section.site') { assigns(:section).site.should == site }
  end

  describe '#preview' do
    render_views
    before :each do
      sign_in user
      get :preview, site_id: site, id: section
    end
    it_responds_200
    it('assigns @section') { assigns(:section).should == section }
  end

  describe '#create' do
    it 'render new with an empty name' do
      sign_in user
      post :create, site_id: site, section: { name: '' }
      response.should render_template :new
      response.should render_template 'admin'
    end

    it 'create a new section' do
      expect do
        sign_in user
        post :create, site_id: site, section: { name: 'test' }
      end.to change { Section.count }.by(1)
    end

    it 'redirect to edit' do
      sign_in user
      post :create, site_id: site, section: { name: 'test' }
      response.should redirect_to edit_section_path(Section.first)
    end

  end

  describe '#destroy' do
    it 'delete the section' do
      section
      expect do
        sign_in user
        delete :destroy, site_id: site, id: section
      end.to change { Section.count }.by(-1)
    end

    it 'redirect to edit site' do
      sign_in user
      delete :destroy, site_id: site, id: section
      response.should redirect_to edit_site_path(id: section.site)
    end
  end

  describe '#update' do

    context 'position' do
      it('update the position') do
        sign_in user
        section
        create :section, site: site
        expect do
          put :update, site_id: site, id: section, section: { position: '2' }
        end.to change { section.reload.position }.to 2
      end

      it('redirect_to edit_site_path') do
        sign_in user
        section
        create :section, site: site
        put :update, site_id: site, id: section, section: { position: '2' }
        response.should redirect_to edit_site_path(id: site)
      end
    end

    it('update the name') do
      expect do
        sign_in user
        put :update, site_id: site, id: section, section: { name: 'test' }
      end.to change { section.reload.name }.to 'test'
    end

    it 'update the theme' do
      expect do
        sign_in user
        put :update, site_id: site, id: section, section: { theme: 'dark' }
      end.to change { section.reload.theme }.to 'dark'
    end

    it('update the description_html') do
      expect do
        sign_in user
        put :update,
            site_id: site,
            id: section,
            section: { description_html: 'test' }
      end.to change { section.reload.description_html }.to 'test'
    end

    it('update the description') do
      expect do
        sign_in user
        put :update,
            site_id: site,
            id: section,
            section: { description: 'test' }
      end.to change { section.reload.description }.to 'test'
    end

    it 'redirect to edit' do
      sign_in user
      put :update, site_id: site, id: section, section: { name: 'test' }
      response.should redirect_to edit_section_path(section.reload)
    end

    it 'flash a message' do
      sign_in user
      put :update, site_id: site, id: section, section: { name: 'test' }
      flash[:success].should == I18n.t('sections.update.success')
    end
  end
end
