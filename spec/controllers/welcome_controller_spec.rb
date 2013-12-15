require 'spec_helper'

describe WelcomeController do
  it 'redirect to Site.first' do
    FactoryGirl.create :site
    get :index
    response.should redirect_to site_path(id: Site.first)
  end
end
