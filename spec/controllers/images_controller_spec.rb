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
      response.should redirect_to edit_page_path(id: image.page)
    end

    it('update the description') do
      expect do
        sign_in user
        put :update, id: image, image: { description: 'test' }
      end.to change { image.reload.description }.to 'test'
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
  context 'ordering' do
    before :each do
      sign_in user
    end
    let(:image2) { FactoryGirl.create :image, page: page }
    let(:image3) { FactoryGirl.create :image, page: page }

    describe '#move_higer' do

      it 'change position' do
        expect do
          put :move_higher, id: image2
        end.to change { image2.reload.position }.by(-1)
      end

      it 'redirect to edit_page' do
        put :move_higher, id: image
        response.should redirect_to edit_page_path page
      end
    end

    describe '#move_lower' do

      it 'change position' do
        image
        image2
        image3
        expect do
          put :move_lower, id: image2
        end.to change { image2.reload.position }.by(1)
      end

      it 'redirect to edit_page' do
        put :move_lower, id: image
        response.should redirect_to edit_page_path page
      end
    end
  end
end
