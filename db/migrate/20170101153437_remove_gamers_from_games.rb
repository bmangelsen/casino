class RemoveGamersFromGames < ActiveRecord::Migration[5.0]
  def change
    remove_column :games, :gamers
  end
end
