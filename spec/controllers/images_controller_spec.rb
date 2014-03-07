require 'spec_helper'

describe ImagesController do
  let(:image) { FactoryGirl.create :image }
  let(:page) { image.page }
  let(:site) { page.site }
  let(:user) { FactoryGirl.create :user }

  describe '#show' do
    render_views

    before :each do
      get :show, id: image
    end
    it_responds_200
    it('assigns site') { assigns(:site).should == site }
    it('assigns page') { assigns(:page).should == page }
    it('assigns image') { assigns(:image).should == image }

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
      put :update, id: image, image: { description: 'test' }
      response.should redirect_to edit_image_path(id: image.reload)
    end



    it 'update the content_css' do
      expect do
        sign_in user
        put :update, id: image, image: { content_css: 'top: 20%;' }
      end.to change { image.reload.content_css }.to 'top: 20%;'
    end

    it 'update the content' do
      expect do
        sign_in user
        put :update, id: image, image: { content: 'test' }
      end.to change { image.reload.content }.to 'test'
    end

    it 'update the description' do
      expect do
        sign_in user
        put :update, id: image, image: { description: 'test' }
      end.to change { image.reload.description }.to 'test'
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

    it 'flash a message' do
      sign_in user
      put :update, id: image, image: { description: 'test' }
      flash[:success].should == I18n.t('images.update.success')
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
