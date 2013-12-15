require 'spec_helper'

describe PagesController do

  describe '#show' do
    let(:page) { FactoryGirl.create :page }
    before :each do
      get :show, {
        site_id: page.site,
        id: page
      }
    end
    it('returns 200') { response.code.should == '200' }
    it('assigns @site') { assigns(:site).should == page.site }
    it('assigns @page') { assigns(:page).should == page }
  end

  describe '#edit' do
    let(:page) { FactoryGirl.create :page }
    before :each do
      get :edit, {
        site_id: page.site,
        id: page
      }
    end
    it('returns 200') { response.code.should == '200' }
    it('assigns @site') { assigns(:site).should == page.site }
    it('assigns @page') { assigns(:page).should == page }
    it('render layout admin') { response.should render_template(:admin) }
  end

end
