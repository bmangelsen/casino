class Deck < ApplicationRecord
  belongs_to :game

  serialize :cards, Array

  VALUE = (2..10).to_a + ["jack", "queen", "king", "ace"]
  SUIT = ["hearts", "spades", "clubs", "diamonds"]

  after_initialize :build_deck

  def build_deck
    return unless cards.empty?
    @deck = []
      VALUE.each do |value|
        SUIT.each do |suit|
          @deck << [value, suit]
        end
      end
    @deck = @deck.shuffle
    self.cards = @deck
  end

  def play_card
    @card = cards.shift
    self.save
    @card
  end
end
