class AddCurrentTurnPlayerToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :current_turn_player, :integer
  end
end
