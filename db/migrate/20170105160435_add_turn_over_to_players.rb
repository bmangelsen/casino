class AddTurnOverToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :turn_over, :boolean, default: false
  end
end
