require 'spec_helper'

describe Site do

  it { should have_many(:pages) }

  describe '#first' do
    it 'return a new site if there is no site' do
      Site.first.should_not be_nil
    end
  end
end
