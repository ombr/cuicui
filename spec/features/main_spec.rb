require 'spec_helper'

describe 'Main features', :feature do
  include CarrierWaveDirect::Test::CapybaraHelpers

  it 'First user can register and create a page and upload a picture.' do
    user = create :user
    visit '/'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'luclucluc'
    click_on 'Sign in'

    find('#new_page').click
    fill_in :page_name, with: 'First Page'
    click_on 'Create Page'

    #Page.first.name.should == 'First Page'
    attach_file_for_direct_upload Rails.root.join('spec', 'fixtures', 'image.jpg')
    upload_directly(FileUploader.new, 'Upload')
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
