require 'spec_helper'
require 'cancan/matchers'

describe User do
  it { should have_many(:sites) }

  describe 'Abilities' do
    let(:user) { create :user }
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
end
