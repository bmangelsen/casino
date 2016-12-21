class CreateDecks < ActiveRecord::Migration[5.0]
  def change
    create_table :decks do |t|
      t.integer :game_id
      
      t.timestamps
    end
  end
end
