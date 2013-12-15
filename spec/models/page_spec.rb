require 'spec_helper'

describe Page do
  it { should belong_to(:site) }
  it { should have_many(:images) }
end
