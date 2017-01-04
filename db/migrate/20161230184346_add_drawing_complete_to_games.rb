class AddDrawingCompleteToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :over, :boolean, default: false
  end
end
