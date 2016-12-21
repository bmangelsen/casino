require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  fixtures :users, :games

  it "can be created" do
    sign_in users(:ben)
    post :create, params: { game: { host: users(:ben) } }
    expect(Game.count).to eq(3)
    expect(response).to redirect_to(game_path(Game.last.id))
  end

  it "can be shown" do
    sign_in users(:ben)
    post :create, params: { game: { host: users(:ben) } }
    get :show, params: {id: Game.last.id}
    expect(response).to render_template(:show)
  end
end
