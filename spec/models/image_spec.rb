require 'spec_helper'

describe Image do
  it { should belong_to :page }

  let(:image) { FactoryGirl.create :image }
  let(:image2) { FactoryGirl.create :image, page: image.page }
  let(:image3) { FactoryGirl.create :image, page: image.page }

  describe '#extract_exifs' do
    it 'extract the exifs from cloudinary' do
      pending 'The factory should be improved first.'
      image
      Cloudinary::Api.should_receive(:resource).and_return({exifs: {key: :value}})
      expect do
        image.extract_exifs
      end.to change{image.exifs}

    end

  end
end
