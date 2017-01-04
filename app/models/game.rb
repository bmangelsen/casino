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
end
