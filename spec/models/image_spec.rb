require 'spec_helper'

describe Image do
  it { should belong_to :page }

  let(:image) { FactoryGirl.create :image }
  let(:image2) { FactoryGirl.create :image, page: image.page }
  let(:image3) { FactoryGirl.create :image, page: image.page }
end
