class RenamePlayersFieldOnGames < ActiveRecord::Migration[5.0]
  def change
    rename_column :games, :players, :gamers
  end
end
