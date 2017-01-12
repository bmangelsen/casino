require 'rails_helper'

RSpec.feature "Deal a card" do
  fixtures :users, :game_types
  it "deals me a card" do
    login_as(users(:ben))
    visit '/'
    click_link 'Join a table!'
    expect(Game.last.human_players[0].cards.count).to eq(2)
    click_link 'Hit'
    expect(Game.last.human_players[0].cards.count).to eq(3)
  end
end
