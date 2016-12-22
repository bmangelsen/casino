class AddOverFieldToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :over, :boolean
  end
end
