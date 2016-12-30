class Deck < ApplicationRecord
  belongs_to :game

  serialize :cards

  VALUE = (2..10).to_a + ["jack", "queen", "king", "ace"]
  SUIT = ["hearts", "spades", "clubs", "diamonds"]

  before_save :build_deck, on: :create

  # def player(current_user)
  #   Player.find_by(user_id: current_user.id, game_id: self.game_id)
  # end
  #
  # def dealer
  #   Player.find_by(user_id: nil, game_id: self.game_id)
  # end

  def build_deck
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
