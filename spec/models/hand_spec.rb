require 'rails_helper'

RSpec.describe Hand, type: :model do
  subject { Hand.new(cards: [["ace", "hearts"]]) }
  it "can have a value" do
    expect(subject.value).to eq(11)
  end

  describe "when multiple cards" do
    it "can have a value" do
      subject.cards << [2, "hearts"]
      expect(subject.value).to eq(13)
    end
  end

  describe "when multiple double aces" do
    it "can have a value" do
      subject.cards << ["ace", "spades"]
      subject.cards << [10, "hearts"]
      expect(subject.value).to eq(12)
    end
  end
end
