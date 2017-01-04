class DropGamesPlayers < ActiveRecord::Migration[5.0]
  def change
    drop_table :games_players
  end
end
