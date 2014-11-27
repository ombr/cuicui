require 'spec_helper'

describe Image do
  it { expect(subject).to belong_to(:section).touch(true) }
  it { expect(subject).to have_one(:site).through(:section) }

  let(:image) { FactoryGirl.create :image }
  let(:image2) { FactoryGirl.create :image, section: image.section }
  let(:image3) { FactoryGirl.create :image, section: image.section }

  describe '#extract_exifs' do
    it 'extract the exifs from cloudinary' do
      pending 'The factory should be improved first.'
      image
      Cloudinary::Api.should_receive(:resource)
        .and_return(exifs: { key: :value })
      expect do
        image.extract_exifs
      end.to change { image.exifs }

    end
  end

  describe '#seo_title' do
    it 'returns a title' do
      image = build :image, title: 'Super Title'
      expect(image.seo_title).to include image.title
    end

    it 'returns the content if there is no title' do
      image = build :image, content: 'Super content', title: ''
      expect(image.seo_title).to include image.content
    end

    it 'returns the legend it there is no title or content' do
      image = build :image, title: '', content: '', legend: 'Super legend'
      expect(image.seo_title).to include image.legend
    end

    it 'returns section name if content, title and legend are empty' do
      image = build :image, title: '', content: '', legend: ''
      expect(image.seo_title).to eq image.section.name
    end
  end

  describe '#seo_description' do
    it 'returns the content' do
      image = build :image, title: 'test', content: 'Super Title'
      expect(image.seo_description).to eq image.content
    end

    it 'returns the legend if no content' do
      image = build :image, title: 'test', content: '', legend: 'Super legend'
      expect(image.seo_description).to eq image.legend
    end
  end

  describe '#priority' do
    it 'return the right value' do
      section = create :section
      image1 = create :image, section: section
      image2 = create :image, section: section
      image3 = create :image, section: section
      image1.priority.should eql(1.0)
      image2.priority.should eql(0.6666666666666666)
      image3.priority.should eql(0.3333333333333333)
    end
  end
end
