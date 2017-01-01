class AddPlayersAndWinnerToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :players, :text
    add_column :games, :winner, :text
  end
end
