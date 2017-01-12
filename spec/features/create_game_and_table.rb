require 'rails_helper'

RSpec.feature "Create game and table" do
  fixtures :users, :game_types
  it "can create a game and table" do
    login_as(users(:ben))
    visit '/'
    click_link 'Join a table!'
    expect(page).to have_content 'Your cards:'
  end
end
