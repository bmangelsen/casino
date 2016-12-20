require 'rails_helper'

RSpec.describe Game, type: :model do
  fixtures :players
  fixtures :games

  subject(:game) { described_class.new(message: games(:first).message) }

  it "can add players" do
    expect(game.players.size).to eq(0)
    game.players << players(:ben)
    expect(game.players.size).to eq(1)
  end
end
