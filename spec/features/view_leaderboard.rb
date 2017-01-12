require 'rails_helper'

RSpec.feature "View leaderboard" do
  fixtures :users, :game_types
  it "visits the leaderboard" do
    login_as(users(:ben))
    visit '/'
    click_link "Leaderboard"
    expect(page).to have_content "Blackjack Leaderboard"
  end
end
