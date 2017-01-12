require 'rails_helper'

RSpec.feature "User edit profile" do
  fixtures :users
  it "edits my profile" do
    login_as(users(:ben))
    visit '/'
    click_link 'Edit Profile'
    fill_in 'Password', with: 'password123'
    fill_in 'Password confirmation', with: 'password123'
    fill_in 'Current password', with: 'password'
    click_button 'Update'
    expect(page).to have_content 'Your account has been updated successfully.'
  end
end
