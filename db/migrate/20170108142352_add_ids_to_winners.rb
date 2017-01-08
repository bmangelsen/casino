class AddIdsToWinners < ActiveRecord::Migration[5.0]
  def change
    add_column :winners, :game_id, :integer
    add_column :winners, :player_id, :integer
  end
end
