require 'rails_helper'

RSpec.describe PlayersController, type: :controller do
  fixtures :users, :games

  it "can be created" do
    post :create, params: { player: { user_id: users(:ben).id, game_id: games(:first).id } }
    expect(Player.last.user_id).to eq(users(:ben).id)
    expect(Player.count).to eq(3)
  end

  it "redirects to root if unsaved" do
    post :create, params: { player: { user_id: users(:ben).id } }
    expect(response).to redirect_to(root_path)
  end
end
