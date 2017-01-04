class RenameGamesPlayersToPlayerGames < ActiveRecord::Migration[5.0]
  def change
    rename_table :games_players, :player_games
  end
end
