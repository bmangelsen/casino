require 'rails_helper'

RSpec.describe Hand, type: :model do
  fixtures :users, :players, :games, :decks

  subject(:hand) { described_class.new(cards: [["ace", "hearts"]]) }

  it "can have a value" do
    expect(subject.value).to eq(11)
  end

  describe "when multiple cards" do
    it "can have a value" do
      subject.cards << [2, "hearts"]
      expect(subject.value).to eq(13)
    end
  end

  describe "when multiple aces" do
    it "can have a value" do
      subject.cards << [10, "spades"]
      subject.cards << ["ace", "spades"]
      expect(subject.value).to eq(12)
    end
  end

  it "can belong to a player" do
    expect(subject.belongs_to_player?(players(:ben).id, users(:ben))).to eq(true)
  end

  it "can belong to a dealer" do
    expect(subject.belongs_to_player?(players(:tom).id, users(:ben))).to eq(false)
  end

  it "can deal a card" do
    subject.player = players(:ben)
    subject.player.game.deck.build_deck
    expect(subject.value).to eq(11)
    subject.deal
    expect(subject.cards.count).to eq(2)
  end

  it "can add jack" do
    subject.cards << ["jack", "spades"]
    expect(subject.value).to eq(21)
  end

  it "can add queen" do
    subject.cards << ["queen", "spades"]
    expect(subject.value).to eq(21)
  end

  it "can add king" do
    subject.cards << ["king", "spades"]
    expect(subject.value).to eq(21)
  end
end
