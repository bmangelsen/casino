class AddTableToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :table_id, :integer
  end
end
