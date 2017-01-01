require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  fixtures :users, :games, :decks

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

  it "can create players" do
    sign_in users(:ben)
    post :create, params: { game: { host: users(:ben) } }
    expect(Game.last.players.count).to eq(2)
  end

  # it "can declare winner on draw" do
  #   sign_in users(:ben)
  #   post :create, params: { game: { host: users(:ben) } }
  #   ben = Player.find_by(user_id: users(:ben).id)
  #   ben.create_hand(Game.last.deck)
  #   ben.cards.clear
  #   ben.cards << ["ace", "diamonds"]
  #   ben.cards << [10, "hearts"]
  #   redirect_to(game_path(Game.last.id))
  #   redirect_to(root_path)
  #   expect(Game.last.winner).to eq(ben)
  # end
end
