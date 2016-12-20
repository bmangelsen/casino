require 'rails_helper'

RSpec.describe Player, type: :model do
  fixtures :users, :games

  subject(:player) { described_class.new(user_id: users(:ben).id, game_id: games(:first).id) }

  it "has a user and game" do
    expect(player.user_id).to eq(users(:ben).id)
    expect(player.game_id).to eq(games(:first).id)
  end
end
