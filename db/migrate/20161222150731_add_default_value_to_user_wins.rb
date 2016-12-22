class AddDefaultValueToUserWins < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :wins, :integer, default: 0
  end
end
