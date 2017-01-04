class Game < ApplicationRecord
  has_many :player_games
  has_many :players, through: :player_games
  has_many :hands
  has_one :deck
  belongs_to :table

  def setup
    self.build_deck
    self.add_players
    self.create_player_hands
    save
    self.add_own_id_to_players
  end

  def create_player_hands
    players.each do |player|
      player.create_hand(self.deck)
    end
  end

  def add_players
    self.players = table.players
  end

  def add_own_id_to_players
    self.players.each do |player|
      player.update(game_id: self.id)
    end
  end

  def player(current_user)
    Player.find_by(user_id: current_user.id, game_id: self.id)
  end

  def dealer
    Player.find_by(user_id: nil, game_id: self.id)
  end

  def dealer_hand_value
    dealer.hand.value
  end

  def player_hand_value(current_user)
    player(current_user).hand.value
  end

  def has_winner?(current_user)
    if player_hand_value(current_user) >= 21 || dealer_hand_value >= 21 || self.over == true
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

  def human_players
    players.where.not(user: nil)
  end
end
