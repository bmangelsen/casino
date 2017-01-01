class AddPlaysToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :plays, :integer
  end
end
