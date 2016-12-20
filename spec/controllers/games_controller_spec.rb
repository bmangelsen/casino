require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  fixtures :users, :games

  it "can be created" do
    post :create, params: { game: { message: games(:first).message } }
    expect(Game.last.message).to eq("The game has begun!")
    expect(Game.count).to eq(3)
  end
end
