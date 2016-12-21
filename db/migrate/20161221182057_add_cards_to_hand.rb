class AddCardsToHand < ActiveRecord::Migration[5.0]
  def change
    add_column :hands, :cards, :text
  end
end
