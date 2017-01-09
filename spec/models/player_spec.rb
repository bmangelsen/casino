require 'rails_helper'

RSpec.describe Player, type: :model do
  fixtures :users, :games, :decks
  subject(:player) { described_class.new(user_id: users(:ben).id, game_id: games(:first).id) }

  it "has a user and game" do
    expect(subject.user_id).to eq(users(:ben).id)
    expect(subject.game_id).to eq(games(:first).id)
  end

  it "can hold cards" do
    decks(:first).build_deck
    subject.create_hand(decks(:first))
    expect(subject.cards.count).to eq(2)
  end

  it "can have an email based on user" do
    expect(subject.email).to eq("ben@gmail.com")
  end
end
