class RemoveWinnerFromGamesAgain < ActiveRecord::Migration[5.0]
  def change
    remove_column :games, :winner
  end
end
