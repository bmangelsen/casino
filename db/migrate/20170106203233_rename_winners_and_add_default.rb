class RenameWinnersAndAddDefault < ActiveRecord::Migration[5.0]
  def change
    rename_column :games, :winners, :winner
    change_column :games, :winner, :text, array: true, default: []
  end
end
