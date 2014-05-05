require 'spec_helper'

describe Page do
  it { should belong_to(:site).touch(true) }
  it { should have_many(:images) }
  it { should validate_presence_of(:name) }
end
