require 'rails_helper'

RSpec.describe TablesController, type: :controller do
  fixtures :users, :games, :decks, :tables, :players

  before(:each) do
    @table = Table.create
    @table.players << players(:ben)
    @table.players << players(:dealer)
    @game = Game.create(host: users(:ben).id, table_id: @table.id)
    @game.setup
    @ben = Player.find_by(game_id: @game.id, user_id: users(:ben).id, table_id: @table.id)
    @dealer = Player.find_by(game_id: @game.id, user_id: nil, table_id: @table.id)
  end

  it "can join a table that exists" do
    sign_in users(:tom)
    get :join_table
    expect(@table.players.count).to eq(3)
  end

  it "can create a table when none exist" do
    sign_in users(:tom)
    Table.delete_all
    expect(Table.all.count).to eq(0)
    get :join_table
    expect(Table.all.count).to eq(1)
  end

  it "can send to waiting path" do
    sign_in users(:tom)
    get :waiting, params: {id: @table.id}
    expect(response.status).to eq(200)
  end

  it "can leave a table when the game is over and only 1 human player on table" do
    sign_in users(:ben)
    @game.update!(over: true)
    get :leave_table, params: {id: @table.id}
    expect(Table.all.count).to eq(0)
  end

  it "can delete game and table players when player leaves and game is not over" do
    sign_in users(:ben)
    get :leave_table, params: {id: @table.id}
    expect(Table.all.count).to eq(0)
    expect(@game.human_players.count).to eq(0)
  end

  it "can create a new game if only dealer is left in game but more players waiting on table" do
    @table.players << players(:tom)
    sign_in users(:ben)
    get :leave_table, params: {id: @table.id}
    expect(@table.games.last.human_players[0]).to eq(players(:tom))
  end

  it "can assign host to another human player if not all players have had their turns" do
    @table.players << players(:tom)
    @game.players << players(:tom)
    @game.add_own_id_to_players
    @tom = Player.find_by(game_id: @game.id, user_id: users(:tom).id, table_id: @table.id)
    @tom.create_hand(@game.deck)
    @ben.update!(turn_over: true)
    sign_in users(:ben)
    get :leave_table, params: {id: @table.id}
    @game.reload
    expect(@game.host).to eq(users(:tom).id)
  end

  it "can assign host to another human player if all players have had their turns" do
    @table.players << players(:tom)
    @game.players << players(:tom)
    @game.add_own_id_to_players
    @tom = Player.find_by(game_id: @game.id, user_id: users(:tom).id, table_id: @table.id)
    @tom.create_hand(@game.deck)
    @ben.update!(turn_over: true)
    @tom.update!(turn_over: true)
    sign_in users(:ben)
    get :leave_table, params: {id: @table.id}
    @game.reload
    expect(@game.host).to eq(users(:tom).id)
  end

  it "can end the game if non-host player leaves and all turns complete" do
    @table.players << players(:tom)
    @game.players << players(:tom)
    @game.add_own_id_to_players
    @tom = Player.find_by(game_id: @game.id, user_id: users(:tom).id, table_id: @table.id)
    @tom.create_hand(@game.deck)
    @ben.update!(turn_over: true)
    sign_in users(:tom)
    get :leave_table, params: {id: @table.id}
    @game.reload
    expect(@game.over).to eq(true)
  end

  it "can set next player's turn if non-host player leaves" do
    @table.players << players(:tom)
    @game.players << players(:tom)
    @game.add_own_id_to_players
    @tom = Player.find_by(game_id: @game.id, user_id: users(:tom).id, table_id: @table.id)
    @tom.create_hand(@game.deck)
    @game.update!(current_turn_player: @tom.id)
    sign_in users(:tom)
    get :leave_table, params: {id: @table.id}
    @game.reload
    expect(@game.current_turn_player).to eq(@ben.id)
  end
end
