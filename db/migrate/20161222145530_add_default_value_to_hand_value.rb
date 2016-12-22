class AddDefaultValueToHandValue < ActiveRecord::Migration[5.0]
  def change
    change_column :hands, :value, :integer, default: 0
  end
end
