require 'spec_helper'

describe 'Main features', :feature do
  include CarrierWaveDirect::Test::CapybaraHelpers

  it 'User can register and create a page and upload a picture.' do
    user = build :user
    visit root_url(subdomain: 'www')
    fill_in 'Email', with: user.email
    click_on 'Create User'

    site = build :site
    fill_in :site_title, with: site.title
    click_on 'Create Site'

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
    click_on 'Create User'
    click_on 'Log Out'
    click_on 'Trouble Signing In'
    fill_in 'Email', with: user.email
    click_on 'Send me reset password instructions'
    open_email user.email
    current_email.click_link 'Change my password'
    fill_in 'New password', with: 'NewPassword'
    click_on 'Change my password'
    User.first.confirmed?.should eq true
  end

  it 'User can reset his password.' do
    user = create :user
    visit '/admin'
    click_on 'Trouble Signing In'

    fill_in 'Email', with: user.email
    click_on 'Send me reset password instructions'

    open_email(user.email)
    current_email.click_link 'Change my password'
    page.fill_in 'user_password', with: 'SuperSecret'
    expect do
      click_on 'Change my password'
    end.to change { user.reload.encrypted_password }
  end

end
