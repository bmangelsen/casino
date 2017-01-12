require 'rails_helper'

RSpec.feature "View game history" do
  fixtures :users
  it "visits my game history" do
    login_as(users(:ben))
    visit '/'
    click_link 'Game History'
    expect(page).to have_content "Here's a quick rundown of your success:"
  end
end
