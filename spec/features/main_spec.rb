require 'spec_helper'

describe 'Main features', :feature do
  include CarrierWaveDirect::Test::CapybaraHelpers

  it 'User can register and create a page and upload a picture.' do
    user = build :user
    visit root_url(subdomain: 'www')
    fill_in 'Email', with: user.email
    save_and_open_page
    click_on 'Sign Up'

    site = build :site
    fill_in 'Title', with: site.title
    click_on 'Create'

    #find('#new_page').click
    #fill_in :page_name, with: 'First Page'
    #click_on 'Create Page'

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
