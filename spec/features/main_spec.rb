require 'spec_helper'

describe 'Main features', :feature do
  include CarrierWaveDirect::Test::CapybaraHelpers

  it 'User can register and create a page and upload a picture.' do
    user = build :user
    visit root_url(subdomain: 'www')
    fill_in 'Email', with: user.email
    find('#btn-register').click

    site = build :site
    save_and_open_page
    find('#new_site').click
    fill_in :site_title, with: site.title
    click_on 'Create Site'

    find('#new_page').click
    fill_in :page_name, with: 'First Page'
    click_on 'Create Page'

    Page.first.name.should eq 'First Page'
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
    visit redirect_url.to_s

    Image.first.exifs['dc']['subject'][0].should_not be_blank
  end

  it 'confirm an user when recovering password' do
    user = build :user
    visit root_url(subdomain: 'www')
    fill_in 'Email', with: user.email
    find('#btn-register').click
    click_on 'Sign out'
    click_on 'Sign In'
    click_on 'Trouble signing in ?'
    fill_in 'user_email', with: user.email
    find('.btn-lg').click
    open_email user.email
    current_email.click_link 'Confirm my account'
    fill_in 'Password', with: 'NewPassword'
    find('.btn-lg').click
    User.first.confirmed?.should eq true
  end

  it 'User can reset his password.' do
    user = create :user
    visit '/'
    click_on 'Sign In'
    click_on 'Trouble signing in ?'

    fill_in 'user_email', with: user.email
    find('.btn-lg').click

    open_email(user.email)
    current_email.click_link 'Change my password'
    page.fill_in 'user_password', with: 'SuperSecret'
    expect do
      click_on 'Change my password'
    end.to change { user.reload.encrypted_password }
  end

end
