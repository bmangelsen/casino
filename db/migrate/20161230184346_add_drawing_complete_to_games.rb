class AddDrawingCompleteToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :drawing_complete, :boolean, default: false
  end
end
