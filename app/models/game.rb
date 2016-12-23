class Game < ApplicationRecord
  has_many :players
  has_many :users, through: :players
  has_one :deck

  def add_player(current_user)
    Player.create(user_id: current_user.id, game_id: self.id)
  end

  def add_dealer
    Player.create(game_id: self.id)
  end

  def player(current_user)
    Player.find_by(user_id: current_user.id, game_id: self.id)
  end

  def dealer
    Player.find_by(user_id: nil, game_id: self.id)
  end
end
