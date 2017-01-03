class AddTableToPlayer < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :table_id, :integer
  end
end
