require 'spec_helper'

describe Site do
  it { should have_many(:pages) }
end
