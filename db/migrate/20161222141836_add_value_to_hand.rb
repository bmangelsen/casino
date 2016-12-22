class AddValueToHand < ActiveRecord::Migration[5.0]
  def change
    add_column :hands, :value, :integer
  end
end
