require 'rails_helper'

RSpec.describe HandsController, type: :controller do
  fixtures :users, :games, :decks, :tables, :players

  before(:each) do
    @table = Table.create
    @table.players << players(:ben)
    @table.players << players(:tom)
    @table.players << players(:dealer)
    @game = Game.create(table: @table)
    @game.setup
    @ben = Player.find_by(game_id: @game.id, user_id: users(:ben).id, table_id: @table.id)
    @tom = Player.find_by(game_id: @game.id, user_id: users(:tom).id, table_id: @table.id)
    @dealer = Player.find_by(game_id: @game.id, user_id: nil, table_id: @table.id)
  end

  it "can draw a card" do
    sign_in users(:ben)
    @ben.hand.update!(cards: [[2, "hearts"], [3, "hearts"]])
    expect(@ben.hand.cards.count).to eq(2)
    patch :update, params: {id: @ben.hand.id}
    @ben.reload
    expect(@ben.hand.cards.count).to eq(3)
  end

  it "can have stand param and go to next player's turn" do
    sign_in users(:ben)
    @ben.hand.update!(cards: [[2, "hearts"], [3, "hearts"]])
    patch :update, params: {id: @ben.hand.id, stand: "stand"}
    @game.reload
    expect(@game.current_turn_player).to eq(@tom.id)
  end

  it "can have stand param and go to dealer's turn" do
    sign_in users(:ben)
    @tom.update!(turn_over: true)
    @tom.hand.update!(cards: [["king", "spades"], ["king", "clubs"]])
    @ben.hand.update!(cards: [[2, "hearts"], [3, "hearts"]])
    @dealer.hand.update!(cards: [[2, "hearts"], [3, "hearts"]])
    patch :update, params: {id: @ben.hand.id, stand: "stand"}
    @tom.reload
    @ben.reload
    @dealer.reload
    @game.reload
    expect(@dealer.hand.cards.count).to be > 2
    expect(@game.over).to eq(true)
  end

  it "can bust a hand and go to next player's turn" do
    sign_in users(:ben)
    @ben.hand.update!(cards: [[11, "hearts"], ["queen", "hearts"]])
    patch :update, params: {id: @ben.hand.id}
    @game.reload
    expect(@game.current_turn_player).to eq(@tom.id)
  end

  it "can bust a hand and go to dealer's turn" do
    sign_in users(:ben)
    @tom.update!(turn_over: true)
    @tom.hand.update!(cards: [["king", "spades"], ["king", "clubs"]])
    @ben.hand.update!(cards: [[11, "hearts"], ["queen", "hearts"]])
    @dealer.hand.update!(cards: [[2, "hearts"], [3, "hearts"]])
    patch :update, params: {id: @ben.hand.id}
    @tom.reload
    @ben.reload
    @dealer.reload
    @game.reload
    expect(@dealer.hand.cards.count).to be > 2
    expect(@game.over).to eq(true)
  end

  it "can hit 21 and go to next player's turn" do
    sign_in users(:ben)
    @ben.hand.update!(cards: [["king", "hearts"], ["queen", "hearts"]])
    @game.deck.update!(cards: [["ace", "hearts"], ["ace", "hearts"], ["ace", "hearts"]])
    patch :update, params: {id: @ben.hand.id}
    @ben.reload
    @game.reload
    expect(@game.current_turn_player).to eq(@tom.id)
  end

  it "can hit 21 and go to dealer's turn" do
    sign_in users(:ben)
    @tom.update!(turn_over: true)
    @tom.hand.update!(cards: [["king", "spades"], ["king", "clubs"]])
    @ben.hand.update!(cards: [["king", "hearts"], ["queen", "hearts"]])
    @game.deck.update!(cards: [["ace", "hearts"], ["ace", "hearts"]])
    @dealer.hand.update!(cards: [[8, "hearts"], [8, "hearts"]])
    patch :update, params: {id: @ben.hand.id}
    @tom.reload
    @ben.reload
    @dealer.reload
    @game.reload
    expect(@dealer.hand.cards.count).to be > 2
    expect(@game.over).to eq(true)
  end
end
