class Player < ApplicationRecord
  belongs_to :user
  belongs_to :table
  has_many :player_games
  has_many :games, through: :player_games
  has_many :winners
  has_one :hand

  def cards
    self.hand.cards
  end

  def game
    hand.game
  end

  def create_hand(deck)
    self.hand = Hand.create(cards: [deck.play_card, deck.play_card], game_id: deck.game_id)
  end

  def email
    self.user.email
  end
end
