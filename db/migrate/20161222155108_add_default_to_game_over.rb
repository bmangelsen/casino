class AddDefaultToGameOver < ActiveRecord::Migration[5.0]
  def change
    change_column :games, :over, :boolean, default: false
  end
end
