require 'spec_helper'

describe RegistrationsController do

  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe '#create' do
    let(:user) { build :user }
    context 'when user does not exists' do
      it 'create the user' do
        expect do
          post :create, user: {
            email: user.email
          }
        end.to change { User.count }.by(1)
      end
    end

    context 'when the user exixts' do
      let(:user) { create :user }
      before :each do
        user
      end

      context 'when user is not confirmed' do
        let(:user) { create :user, confirmed_at: nil }

        it 'send a confirmation email'

        it 'flash a message' do
          post :create, user: {
            email: user.email
          }
          flash[:notice].should_not be_nil
        end
      end
      context 'when the user is confirmed' do
        it 'send a reset password email'

        it 'flash a message' do
          post :create, user: {
            email: user.email
          }
          flash[:notice].should_not be_nil
        end
      end
    end
  end

  describe '#destroy' do
    pending
  end
end
