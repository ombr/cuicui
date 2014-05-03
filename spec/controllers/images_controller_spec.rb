require 'spec_helper'

describe ImagesController do
  let(:image) { FactoryGirl.create :image }
  let(:page) { image.page }
  let(:site) { page.site }
  let(:user) { FactoryGirl.create :user }

  describe '#show' do
    render_views

    context 'render_view' do
      before :each do
        get :show, id: image
      end
      it_responds_200
      it('assigns site') { assigns(:site).should == site }
      it('assigns page') { assigns(:page).should == page }
      it('assigns image') { assigns(:image).should == image }

      it 'uses http caching' do
        response.headers['ETag'].should be_present
      end
    end

    context 'with site.twitter_id defined' do
      it 'render the meta' do
        site.update(twitter_id: '@ombr')
        get :show, id: image
        expect(
          response.body
        ).to include "<meta content='@ombr' property='twitter:site'>"
        expect(
          response.body
        ).to include "<meta content='@ombr' property='twitter:creator'>"
      end
    end

    context 'with site.facebook_id defined' do
      it 'render the meta' do
        site.update(facebook_id: 'ombr')
        get :show, id: image
        expect(
          response.body
        ).to include "<meta content='ombr' property='fb:admins'>"
      end
    end

    context 'with site.google_plus_id defined' do
      it 'render the meta' do
        site.update(google_plus_id: '1212')
        get :show, id: image
        expect(
          response.body
        ).to include(
          "<link href='https://plus.google.com/1212/posts' rel='author'>"
        )
      end
    end

    context 'with site.facebook_app_id defined' do
      it 'render the meta' do
        site.update(facebook_app_id: '1212')
        get :show, id: image
        expect(
          response.body
        ).to include "<meta content='1212' property='og:app_id'>"
      end
    end

  end

  describe '#edit' do
    before :each do
      sign_in user
    end

    before :each do
      get :edit, id: image
    end

    it_responds_200
    it('assigns site') { assigns(:site).should == site }
    it('assigns page') { assigns(:page).should == page }
    it('assigns image') { assigns(:image).should == image }
    it('render layout admin') { response.should render_template(:admin) }
  end

  describe '#update' do
    before :each do
      sign_in user
    end

    it 'redirect to edit' do
      sign_in user
      put :update, id: image, image: { legend: 'test' }
      response.should redirect_to edit_image_path(id: image.reload)
    end

    it 'update the content_css' do
      expect do
        sign_in user
        put :update, id: image, image: { content_css: 'top: 20%;' }
      end.to change { image.reload.content_css }.to 'top: 20%;'
    end

    it 'update the image_css' do
      expect do
        sign_in user
        put :update, id: image, image: { image_css: 'top: 20%;' }
      end.to change { image.reload.image_css }.to 'top: 20%;'
    end

    it 'update the content' do
      expect do
        sign_in user
        put :update, id: image, image: { content: 'test' }
      end.to change { image.reload.content }.to 'test'
    end

    it 'update the legend' do
      expect do
        sign_in user
        put :update, id: image, image: { legend: 'test' }
      end.to change { image.reload.legend }.to 'test'
    end

    it 'update the title' do
      expect do
        sign_in user
        put :update, id: image, image: { title: 'test' }
      end.to change { image.reload.title }.to 'test'
    end

    context 'when update the position' do
      it 'update the position using insert_at' do
        Image.any_instance.should_receive(:insert_at).with(2)
        sign_in user
        put :update, id: image, image: { position: 2 }
      end

      it 'redirect to edit page' do
        sign_in user
        put :update, id: image, image: { position: 2 }
        response.should redirect_to edit_page_path(id: image.page)
      end

    end

    it 'update full' do
      expect do
        sign_in user
        put :update, id: image, image: { full: true }
      end.to change { image.reload.full }.to true
    end
  end

  describe '#delete' do
    before :each do
      sign_in user
    end

    it 'delete the image' do
      delete :destroy, id: image
      Image.find_by_id(image.id).should be_nil
    end

    it 'redirect to edit_page' do
      delete :destroy, id: image
      response.should redirect_to edit_page_path page
    end
  end
end
