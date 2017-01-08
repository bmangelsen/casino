class CreateWinners < ActiveRecord::Migration[5.0]
  def change
    create_table :winners do |t|

      t.timestamps
    end
  end
end
