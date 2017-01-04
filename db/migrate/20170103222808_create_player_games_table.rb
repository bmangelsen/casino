class CreatePlayerGamesTable < ActiveRecord::Migration[5.0]
  def change
    create_join_table :players, :games do |t|
        t.integer :player_id
        t.integer :game_id
    end
  end
end
