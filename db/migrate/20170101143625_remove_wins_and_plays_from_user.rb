class RemoveWinsAndPlaysFromUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :wins
    remove_column :users, :plays
  end
end
