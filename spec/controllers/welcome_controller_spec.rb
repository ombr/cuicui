require 'spec_helper'

describe WelcomeController do

  it 'redirect to edit if current_user' do
    sign_in FactoryGirl.create :user
    get :index
    response.should redirect_to edit_site_path(id: Site.first)
  end

  context 'when site exists' do
    it 'redirect to edit if current_user' do
      FactoryGirl.create :site
      sign_in FactoryGirl.create :user
      get :index
      response.should redirect_to edit_site_path(id: Site.first)
    end
  end

  it 'redirect to login if there is no site' do
    get :index
    response.should redirect_to new_user_session_path
  end

  it 'redirect to Site.first' do
    FactoryGirl.create :site
    get :index
    response.should redirect_to site_path(id: Site.first)
  end
end
