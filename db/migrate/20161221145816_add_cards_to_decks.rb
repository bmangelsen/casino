class AddCardsToDecks < ActiveRecord::Migration[5.0]
  def change
    add_column :decks, :cards, :text
  end
end
