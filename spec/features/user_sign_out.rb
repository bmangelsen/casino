require 'rails_helper'

RSpec.feature "User sign out" do
  fixtures :users
  it "signs me out" do
    login_as(users(:ben))
    visit '/'
    click_link 'Log Out'
    expect(page).to have_content 'Signed out successfully'
  end
end
