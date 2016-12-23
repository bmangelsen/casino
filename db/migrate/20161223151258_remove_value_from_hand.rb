class RemoveValueFromHand < ActiveRecord::Migration[5.0]
  def change
    remove_column :hands, :value
  end
end
