require 'spec_helper'
require 'cancan/matchers'

describe User do
  let(:user) { create :user }
  it { should have_many(:sites).dependent(:destroy) }

  describe 'Abilities' do
    subject { Ability.new(user) }

    it { should be_able_to(:create, Site) }

    describe 'when it own a site' do
      let(:site) { create :site, user: user }
      it { should be_able_to(:update, site) }
    end

    describe 'another site' do
      let(:site) { create :site }
      it { should_not be_able_to(:update, site) }
    end
  end

  describe 'password?' do
    it 'return false if user does not have a password' do
      expect(user.password?).to eq true
    end

    context 'when user does not have a password' do
      let(:user) { create :user, password: '' }

      it 'return false if user does not have a password' do
        expect(user.password?).to eq false
      end

      it 'when password is not saved' do
        user.update password: 'a'
        expect(user.password?).to eq false
      end
    end
  end
end
