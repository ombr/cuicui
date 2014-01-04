require 'spec_helper'

describe 'Main features', :feature do
  it 'First user can register and create a page.' do
    user = FactoryGirl.create :user
    visit '/'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'luclucluc'
    click_on 'Sign in'

    find('#new_page').click
    fill_in :page_name, with: 'First Page'
    click_on 'Create Page'

    Page.first.name.should == 'First Page'
  end

end
