require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  fixtures :users, :games

  it "can be created" do
    post :create, params: { game: { message: games(:first).message } }
    expect(Game.last.message).to eq("The game has begun!")
    expect(Game.count).to eq(3)
    expect(response).to redirect_to(game_path(Game.last.id))
  end

  it "can be shown" do
    get :show, params: {id: Game.last.id}
    expect(response).to render_template(:show)
  end
end
