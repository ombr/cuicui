require 'spec_helper'

describe ImagesController do
  include RouteHelper
  let(:image) { create :image, section: section }
  let(:section) { create :section, site: site }
  let(:site) { create :site, user: user }
  let(:user) { create :user }

  describe '#new' do
    it 'responds 200' do
      sign_in user
      get :new, site_id: site, section_id: section, format: :json
      expect(response.code).to eq '200'
    end
  end

  describe '#add' do
    include CarrierWaveDirect::Test::Helpers
    it 'redirect_to edit_section_path' do
      skip 'Already tested as a feature ?'
      sign_in user
      get :add, site_id: site,
                section_id: section,
                key: sample_key(FileUploader.new)
      response.should redirect_to edit_section_path(section)
    end

    it 'fix positions when they are failling' do
      image
      image1 = create :image, section: section
      Image.where(id: image1.id).update_all(position: 1)
      expect do
        section.images.race_fix
      end.to change { image1.reload.position }.to(2)
    end
  end

  describe '#show' do
    render_views

    it 'redirects to section when image not found' do
      @request.host = "#{section.site.slug}.#{ENV['DOMAIN']}"
      get :show, section_id: section.slug, id: 'asdasdasd'
      expect(response).to redirect_to s_section_path(id: section)
    end

    it 'redirects when section slug changed' do
      @request.host = "#{section.site.slug}.#{ENV['DOMAIN']}"
      previous_slug = section.slug
      section.update name: 'hey hey hey'
      get :show, section_id: previous_slug, id: image
      expect(response).to redirect_to section_id: section
    end

    context 'render_view' do
      before :each do
        get :show, site_id: site, section_id: section, id: image
      end
      it_responds_200
      it('assigns site') { assigns(:site).should == site }
      it('assigns section') { assigns(:section).should == section }
      it('assigns image') { assigns(:image).should == image }

      it 'uses http caching' do
        response.headers['ETag'].should be_present
      end

      it 'invalidate caching on update' do
        get :show, site_id: site, section_id: section, id: image
        etag = response.headers['ETag']
        image.touch
        assigns(:image).reload
        get :show, site_id: site, section_id: section, id: image
        response.headers['ETag'].should_not eq etag
      end
    end

    context 'with site.twitter_id defined' do
      it 'render the meta' do
        site.update(twitter_id: '@ombr')
        get :show, site_id: site, section_id: section, id: image
        expect(
          response.body
        ).to include "<meta content=\"@ombr\" property=\"twitter:site\" />"
        expect(
          response.body
        ).to include "<meta content=\"@ombr\" property=\"twitter:creator\" />"
      end
    end

    context 'with site.facebook_id defined' do
      it 'render the meta' do
        site.update(facebook_id: 'ombr')
        get :show, site_id: site, section_id: section, id: image
        expect(
          response.body
        ).to include "<meta content=\"ombr\" property=\"fb:admins\" />"
      end
    end

    context 'with site.google_plus_id defined' do
      it 'render the meta' do
        site.update(google_plus_id: '1212')
        get :show, site_id: site, section_id: section, id: image
        expect(
          response.body
        ).to include(
          "<link href=\"https://plus.google.com/1212/posts\" rel=\"author\" />"
        )
      end
    end

    context 'with site.facebook_app_id defined' do
      it 'render the meta' do
        site.update(facebook_app_id: '1212')
        get :show, site_id: site, section_id: section, id: image
        expect(
          response.body
        ).to include "<meta content=\"1212\" property=\"og:app_id\" />"
      end
    end

  end

  describe '#edit' do
    before :each do
      sign_in user
    end

    before :each do
      get :edit, site_id: site, section_id: section, id: image
    end

    it_responds_200
    it('assigns site') { assigns(:site).should == site }
    it('assigns section') { assigns(:section).should == section }
    it('assigns image') { assigns(:image).should == image }
    it('render layout admin') { response.should render_template(:admin) }
  end

  describe '#update' do
    before :each do
      sign_in user
    end

    it 'redirect to edit' do
      sign_in user
      put :update, site_id: site,
                   section_id: section,
                   id: image,
                   image: { legend: 'test' }
      response.should redirect_to edit_image_path(image.reload)
    end

    it 'update the content_css' do
      expect do
        sign_in user
        put :update, site_id: site,
                     section_id: section,
                     id: image,
                     image: { content_css: 'top: 20%;' }
      end.to change { image.reload.content_css }.to 'top: 20%;'
    end

    it 'update the image_css' do
      expect do
        sign_in user
        put :update, site_id: site,
                     section_id: section,
                     id: image,
                     image: { image_css: 'top: 20%;' }
      end.to change { image.reload.image_css }.to 'top: 20%;'
    end

    it 'update the focus' do
      expect do
        sign_in user
        put :update, site_id: site,
                     section_id: section,
                     id: image,
                     image: { focusx: '20.2', focusy: '12.5' }
      end.to change { image.reload.focusx }.to 20.2
      image.focusy.should eq 12.5
    end

    it 'update the content' do
      expect do
        sign_in user
        put :update, site_id: site,
                     section_id: section,
                     id: image,
                     image: { content: 'test' }
      end.to change { image.reload.content }.to 'test'
    end

    it 'update the legend' do
      expect do
        sign_in user
        put :update, site_id: site,
                     section_id: section,
                     id: image,
                     image: { legend: 'test' }
      end.to change { image.reload.legend }.to 'test'
    end

    it 'update the title' do
      expect do
        sign_in user
        put :update, site_id: site,
                     section_id: section,
                     id: image,
                     image: { title: 'test' }
      end.to change { image.reload.title }.to 'test'
    end

    context 'when update the position' do
      it 'update the position' do
        sign_in user
        image
        create :image, section: section
        expect do
          put :update, site_id: site,
                       section_id: section,
                       id: image,
                       image: { position: 2 }
        end.to change { image.reload.position }.to(2)
      end

      it 'redirect to edit section' do
        sign_in user
        put :update, site_id: site,
                     section_id: section,
                     id: image,
                     image: { position: 2 }
        response.should redirect_to edit_section_path(image.section)
      end

    end

    it 'update full' do
      expect do
        sign_in user

        put :update, site_id: site,
                     section_id: section,
                     id: image,
                     image: { full: true }
      end.to change { image.reload.full }.to true
    end
  end

  describe '#destroy' do
    before :each do
      sign_in user
    end

    it 'delete the image' do
      delete :destroy, site_id: site, section_id: section, id: image
      Image.find_by_id(image.id).should be_nil
    end

    it 'redirect to edit_section' do
      delete :destroy, site_id: site, section_id: section, id: image
      response.should redirect_to edit_section_path section
    end
  end
end
