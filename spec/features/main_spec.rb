require 'spec_helper'

describe 'Main features', :feature do
  include CarrierWaveDirect::Test::CapybaraHelpers

  it 'User can register and create a page and upload a picture.' do
    user = build :user
    visit "http://www.#{ENV['DOMAIN']}"
    fill_in 'user[email]', with: user.email
    find('input[type=submit]').click

    site = build :site
    find('#new_site').click
    fill_in :site_title, with: site.title
    find('.new-site-submit').click

    Page.first.name.should eq I18n.t('sites.create.first_page')
    uploader = FileUploader.new
    upload_path = Rails.root.join('spec', 'fixtures', 'image.jpg')
    redirect_key = sample_key(
      uploader,
      base: find_key,
      filename: File.basename(upload_path)
    )
    uploader.key = redirect_key
    s3_url = uploader.direct_fog_url(with_path: true)

    redirect_url = URI.parse(
      page.find("input[name='success_action_redirect']", visible: false).value
    )
    redirect_url.query = Rack::Utils.build_nested_query(
      bucket: uploader.fog_directory,
      key: redirect_key,
      etag: '"d41d8cd98f00b204e9800998ecf8427"'
    )

    FakeWeb.register_uri(
      :get,
      Regexp.new("#{s3_url}.*"),
      body: File.open(upload_path)
    )
    visit "http://www.#{ENV['DOMAIN']}#{redirect_url}"

    Image.first.exifs['dc']['subject'][0].should_not be_blank
  end

  it 'confirm an user when recovering password' do
    user = build :user
    visit "http://www.#{ENV['DOMAIN']}"
    fill_in 'user[email]', with: user.email
    find('input[type=submit]').click
    find('.sign-out').click
    find('.sign-in').click
    find('.trouble').click
    fill_in 'user_email', with: user.email
    find('.btn-lg').click
    open_email user.email
    current_email.click_link 'a'
    fill_in 'user_password', with: 'NewPassword'
    find('.btn-lg').click
    User.first.confirmed?.should eq true
  end

  it 'User can reset his password.' do
    user = create :user
    visit "http://www.#{ENV['DOMAIN']}"
    find('.sign-in').click
    find('.trouble').click

    fill_in 'user_email', with: user.email
    find('.btn-lg').click

    open_email(user.email)
    current_email.click_link 'a'
    page.fill_in 'user_password', with: 'SuperSecret'
    expect do
      click_on 'Change my password'
    end.to change { user.reload.encrypted_password }
  end

end
