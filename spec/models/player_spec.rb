require 'rails_helper'

RSpec.describe Player, type: :model do
  fixtures :users, :games, :decks

  subject(:player) { described_class.new(user_id: users(:ben).id, game_id: games(:first).id) }

  it "has a user and game" do
    expect(player.user_id).to eq(users(:ben).id)
    expect(player.game_id).to eq(games(:first).id)
  end

  it "can hold cards" do
    decks(:first).build_deck
    player.create_hand(decks(:first))
    expect(player.cards.count).to eq(2)
  end
end
