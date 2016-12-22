class Deck < ApplicationRecord
  belongs_to :game

  serialize :cards

  VALUE = (2..10).to_a + ["jack", "queen", "king", "ace"]
  SUIT = ["hearts", "spades", "clubs", "diamonds"]

  def create_player_hand(current_user)
    Player.find_by(user_id: current_user.id, game_id: self.game_id).create_hand(self)
  end

  def create_dealer_hand
    Player.find_by(user_id: nil, game_id: self.game_id).create_hand(self)
  end

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

  def player_winner(player_hand)
    @user = User.find(Player.find(player_hand.player_id).user_id)
    @user.wins += 1
    @user.save
    Game.find(Player.find(player_hand.player_id).game_id).update(over: true)
  end
end
