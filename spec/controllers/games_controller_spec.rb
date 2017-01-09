require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  fixtures :users, :games, :decks, :tables, :players

  before(:each) do
    @table = Table.create
    @table.players << players(:ben)
    @table.players << players(:tom)
  end

  it "can be created" do
    sign_in users(:ben)
    post :create, params: { game: { host: users(:ben).id, table_id: @table.id } }
    expect(Game.count).to eq(2)
    expect(response).to redirect_to(game_path(Game.last.id))
  end

  it "can be shown" do
    sign_in users(:ben)
    post :create, params: { game: { host: users(:ben).id, table_id: @table.id } }
    get :show, params: {id: Game.last.id}
    expect(response).to render_template(:show)
  end

  it "can create players" do
    sign_in users(:ben)
    post :create, params: { game: { host: users(:ben).id, table_id: @table.id } }
    expect(Game.last.players.count).to eq(2)
  end
end
