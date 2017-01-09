require 'rails_helper'

RSpec.describe UserHelper, type: :helper do
  fixtures :games, :players, :users

  before(:each) do
    @user = users(:ben)
    @player = Player.create(user: @user)
    @game = games(:first)
  end

  it "can get count of won games for a user" do
    expect(@game.winners.count).to eq(0)
    @game.winners.create(game_id: @game.id, player_id: @player.id)
    expect(won_games_for(@user)).to eq(1)
  end

  it "can identify all users" do
    expect(find_users.count).to eq(2)
  end

  it "can count all users" do
    expect(count_users).to eq(2)
  end

  it "can display all users' emails" do
    expect(display_user_emails).to eq(["ben@gmail.com", "tom@gmail.com"])
  end
end
