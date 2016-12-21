require 'rails_helper'

RSpec.describe Deck, type: :model do
  fixtures :games

  subject(:game) { described_class.new(game_id: games(:first).id) }

  it "can build a deck" do
    game.build_deck
    expect(game.cards.count).to eq(52)
  end

  it "can play a card" do
    game.build_deck
    game.play_card
    expect(game.cards.count).to eq(51)
  end
end
