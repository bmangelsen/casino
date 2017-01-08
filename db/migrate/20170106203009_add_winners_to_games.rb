class AddWinnersToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :winners, :text, array: true
  end
end
