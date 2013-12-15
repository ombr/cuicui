require 'spec_helper'

describe WelcomeController do

  it 'create first site and redirect to edit if there is no site' do
    get :index
    response.should redirect_to edit_site_path(id: Site.first)
  end

  it 'redirect to Site.first' do
    FactoryGirl.create :site
    get :index
    response.should redirect_to site_path(id: Site.first)
  end
end
