require 'rails_helper'

RSpec.describe HandsController, type: :controller do
  fixtures :users, :games, :decks, :tables, :players
  
  before(:each) do
    @table = Table.create
    @table.players << players(:ben)
    @table.players << players(:tom)
    @table.players << players(:dealer)
    @game = Game.create(table_id: @table.id)
    @game.setup
  end

  it "can draw a card" do
  binding.pry
  end
end
