require 'spec_helper'

describe RegistrationsController do

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe '#create' do
    let(:user) { build :user }
    context 'when user does not exists' do
      it 'create the user' do
        expect do
          post :create, user: {
            email: user.email
          }
        end.to change{User.count}.by(1)
      end

      it 'log in the user' do

      end
      it 'send a confirmation email' do

      end
    end

    context 'when the user exixts' do
      context 'when user is not confirmed' do
        it 'flash a message'
        it 'send a confirmation email'
      end
      context 'when the user is confirmed' do
        it 'send a reset password'
        it 'flash a message'
      end
    end
  end

  describe '#destroy' do
    pending
  end
end
