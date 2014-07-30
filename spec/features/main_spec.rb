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
    save_and_open_page

    # Page.first.name.should == 'First Page'
    # attach_file_for_direct_upload Rails.root.join('spec', 'fixtures', 'image.jpg')
    # save_and_open_page
    # upload_directly(FileUploader.new, 'Upload')
  end

  it 'User can reset his password.' do
    user = create :user
    visit '/admin'
    click_on 'Forgot your password?'

    fill_in 'Email', with: user.email
    click_on 'Send me reset password instructions'

    open_email(user.email)
    current_email.click_link 'Change my password'
    page.fill_in 'user_password', with: 'SuperSecret'
    page.fill_in 'user_password_confirmation', with: 'SuperSecret'
    expect do
      click_on 'Change my password'
    end.to change { user.reload.encrypted_password }
  end

end
