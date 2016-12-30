class AddGamesToHands < ActiveRecord::Migration[5.0]
  def change
    add_column :hands, :game_id, :integer
  end
end
