class Table < ApplicationRecord
  has_many :players
  has_many :games

  def self.find_table
    if available_tables.any?
      available_tables.sample
    else
      @table = Table.create
      @table.add_dealer
      @table
    end
  end

  def self.available_tables
    Table.joins(:players).having('COUNT(players.id) < 7').group(:id)
  end

  def add_player(current_user)
    players.create(user_id: current_user.id, table_id: self.id)
  end

  def add_dealer
    players.create(table_id: self.id)
  end

  def has_winner?(current_user)
    if player_has_hand(current_user)
      if player_hand_value(current_user) >= 21 || dealer_hand_value >= 21 || self.games.last.over == true
        true
      end
    end
  end

  def dealer_hand_value
    dealer.hand.value
  end

  def player_has_hand(current_user)
    player(current_user).hand if player(current_user)
  end

  def player_hand_value(current_user)
    player(current_user).hand.value if player_has_hand(current_user)
  end

  def player(current_user)
    Player.find_by(user_id: current_user.id, table_id: self.id)
  end

  def dealer
    Player.find_by(user_id: nil, table_id: self.id)
  end

  def human_players
    players.where.not(user: nil)
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
