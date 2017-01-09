require 'rails_helper'

RSpec.describe PlayersHelper, type: :helper do
  fixtures :users, :games, :decks

  before(:each) do
    @game = games(:first)
    @game.build_deck
    @player = @game.players.create(user_id: users(:ben).id)
    @player.create_hand(decks(:first))
  end

  it "can render object tags for svg files" do
    expect(display_cards_for(@player)).to include("image/svg+xml")
  end

  it "can find human players" do
    expect(@game.players.count).to eq(4)
    expect(human_players(@game).count).to eq(3)
  end
end
