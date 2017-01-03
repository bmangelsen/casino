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
end
