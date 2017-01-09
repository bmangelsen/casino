require 'rails_helper'

RSpec.describe Deck, type: :model do
  fixtures :games
  subject(:deck) { described_class.new(game_id: games(:first).id) }

  it "can be built" do
    subject.build_deck
    expect(subject.cards.count).to eq(52)
  end

  it "can play a card" do
    subject.build_deck
    expect(subject.cards.count).to eq(52)
    subject.cards.shift
    expect(subject.cards.count).to eq(51)
  end
end
