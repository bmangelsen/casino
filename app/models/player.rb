class Player < ApplicationRecord
  belongs_to :game
  belongs_to :user
  has_one :hand

  validates :game_id, presence: true

  def cards
    self.hand.cards
  end

  def create_hand(deck)
    self.hand = Hand.create(cards: [deck.play_card, deck.play_card])
  end
end
