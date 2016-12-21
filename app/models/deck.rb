class Deck < ApplicationRecord
  belongs_to :game

  serialize :cards

  VALUE = (2..10).to_a + ["Jack", "Queen", "King", "Ace"]
  SUIT = ["Hearts", "Spades", "Clubs", "Diamonds"]

  def build_deck
    @deck = []
      VALUE.each do |value|
        SUIT.each do |suit|
          @deck << [value, suit]
        end
      end
    @deck = @deck.shuffle
    self.update(cards: @deck)
  end

  def play_card
    @card = cards.shift
    self.save
    @card
  end
end
