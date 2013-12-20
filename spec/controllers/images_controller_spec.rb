require 'spec_helper'

describe ImagesController do
  describe '#show' do
    render_views

    let(:image) { FactoryGirl.create :image }
    let(:page) { image.page }
    let(:site) { page.site }
    before :each do
      get :show, site_id: site, page_id: page, id: image
    end
    it_responds_200
    it('assigns site') { assigns(:site).should == site }
    it('assigns page') { assigns(:page).should == page }
    it('assigns image') { assigns(:image).should == image }

  end
end
