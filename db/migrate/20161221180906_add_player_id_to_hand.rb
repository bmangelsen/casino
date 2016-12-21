class AddPlayerIdToHand < ActiveRecord::Migration[5.0]
  def change
    add_column :hands, :player_id, :integer
  end
end
