require 'spec_helper'

describe Image do
  it { should belong_to(:page).touch(true) }
  it { should have_one(:site).through(:page) }

  let(:image) { FactoryGirl.create :image }
  let(:image2) { FactoryGirl.create :image, page: image.page }
  let(:image3) { FactoryGirl.create :image, page: image.page }

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
      expect(image.seo_title).to eq image.title
    end

    it 'return the content if there is no title' do
      image = build :image, content: 'Super content', title: ''
      expect(image.seo_title).to eq image.content
    end

    it 'return the legend it there is no title or content' do
      image = build :image, title: '', content: '', legend: 'Super legend'
      expect(image.seo_title).to eq image.legend
    end

    it 'return site and page name if content, title and legend are empty' do
      image = build :image, title: '', content: '', legend: ''
      expect(image.seo_title).to eq "#{image.site.title} : #{image.page.name}"
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
      page = create :page
      image1 = create :image, page: page
      image2 = create :image, page: page
      image3 = create :image, page: page
      image1.priority.should eql(1.0)
      image2.priority.should eql(0.6666666666666666)
      image3.priority.should eql(0.3333333333333333)
    end
  end
end
