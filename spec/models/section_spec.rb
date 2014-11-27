require 'spec_helper'

describe Section do
  it { should belong_to(:site).touch(true) }
  it { should have_many(:images).dependent(:destroy) }
  it { should validate_presence_of(:name) }
end
