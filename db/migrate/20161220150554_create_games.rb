class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.string :message
      t.integer :host
      t.timestamps
    end
  end
end
