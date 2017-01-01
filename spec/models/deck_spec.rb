require 'rails_helper'

RSpec.describe Deck, type: :model do
  fixtures :games

  subject(:deck) { described_class.new(game_id: games(:first).id) }

  it "can be built" do
    deck.build_deck
    expect(deck.cards.count).to eq(52)
  end

  it "can play a card" do
    deck.build_deck
    expect(deck.cards.count).to eq(52)
    deck.cards.shift
    expect(deck.cards.count).to eq(51)
  end
end
