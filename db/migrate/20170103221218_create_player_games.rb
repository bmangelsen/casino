class CreatePlayerGames < ActiveRecord::Migration[5.0]
  def change
    create_join_table :games, :players do |t|
        t.integer :game_id
        t.integer :player_id
    end
  end
end
