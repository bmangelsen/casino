class Game < ApplicationRecord
  has_many :players
  has_many :hands
  has_one :deck

  def add_player(current_user)
    self.players.create(user_id: current_user.id)
  end

  def add_dealer
    self.players.create
  end

  def player(current_user)
    Player.find_by(user_id: current_user.id, game_id: self.id)
  end

  def dealer
    Player.find_by(user_id: nil, game_id: self.id)
  end

  def dealer_hand_value
    self.dealer.hand.value
  end

  def player_hand_value(current_user)
    self.player(current_user).hand.value
  end

  def has_winner?(current_user)
    if player_hand_value(current_user) >= 21 || dealer_hand_value >= 21 || self.drawing_complete == true
      true
    end
  end

  def find_winner(current_user)
    if player_hand_value(current_user) == 21
      player(current_user)
    elsif player_hand_value(current_user) > 21
      dealer
    elsif dealer_hand_value > 21
      player(current_user)
    elsif player_hand_value(current_user) > dealer_hand_value
      player(current_user)
    elsif player_hand_value(current_user) == dealer_hand_value
      nil
    else
      dealer
    end
  end

end
