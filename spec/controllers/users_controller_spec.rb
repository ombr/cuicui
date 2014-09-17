require 'spec_helper'

describe UsersController do
  let(:user) { create :user }
  let(:site) { create :site, user: user }
  describe '#show' do
    render_views
    before :each do
      sign_in user
    end

    it 'responds 200' do
      site
      get :show, id: user
      expect(response.code).to eq '200'
    end

    context 'when user has sites' do
      it 'assigns @sites' do
        site
        get :show, id: user
        expect(assigns(:sites)).to eq [site]
      end
    end
    context 'without sites' do
      it 'redirect to new_site_path' do
        get :show, id: user
        expect(response).to redirect_to new_site_path
      end
    end
  end
end
