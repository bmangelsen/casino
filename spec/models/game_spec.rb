require 'rails_helper'

RSpec.describe Game, type: :model do
  fixtures :players, :games, :users

  before(:each) do
    @table = Table.find_table
    @ben = @table.players.create(table_id: @table.id, user_id: users(:ben).id)
    @tom = @table.players.create(table_id: @table.id, user_id: users(:tom).id)
    @game = Game.create(host: users(:ben).id, table: @table)
    @game.setup
    @user = users(:ben)
    @dealer = @game.dealer
  end

  it "can add players" do
    expect(@game.players.size).to eq(3)
    @game.players.new(game_id: @game.id, user_id: users(:ben).id)
    expect(@game.players.size).to eq(4)
  end

  it "returns false if no next player" do
    @game.human_players[0].update(turn_over: true)
    @game.human_players[1].update(turn_over: true)
    expect(@game.next_players_turn).to eq(false)
  end

  it "can find human players" do
    expect(@game.human_players).to eq([@ben, @tom])
    expect(@game.human_players.count).to eq(2)
  end

  it "can get dealer hand value" do
    expect(@game.dealer_hand_value).to eq(@game.dealer.hand.value)
  end

  it "can get player for a user" do
    expect(@game.player_for(@user)).to eq(@ben)
  end

  it "can get other human players" do
    expect(@game.other_human_players(@ben)).to eq([@tom])
  end

  it "can have a conclusion where dealer wins" do
    @ben.hand.update(cards: [[2, "hearts"], [2, "spades"]])
    @tom.hand.update(cards: [[2, "hearts"], [2, "spades"]])
    @dealer.hand.update(cards: [[2, "hearts"], [3, "spades"]])
    expect(@game.conclusion(@game.id)).to eq("Dealer wins!")
  end

  it "can have a conclusion where ben wins" do
    @ben.hand.update(cards: [[2, "hearts"], [3, "spades"]])
    @tom.hand.update(cards: [[2, "hearts"], [2, "spades"]])
    @dealer.hand.update(cards: [[2, "hearts"], [2, "spades"]])
    expect(@game.conclusion(@game.id)).to eq("The following players win: ben@gmail.com")
  end

  it "can have a conclusion where tom wins" do
    @ben.hand.update(cards: [[2, "hearts"], [2, "spades"]])
    @tom.hand.update(cards: [[2, "hearts"], [3, "spades"]])
    @dealer.hand.update(cards: [[2, "hearts"], [2, "spades"]])
    expect(@game.conclusion(@game.id)).to eq("The following players win: tom@gmail.com")
  end

  it "can have a conclusion where ben and tom win" do
    @ben.hand.update(cards: [[2, "hearts"], [3, "spades"]])
    @tom.hand.update(cards: [[2, "hearts"], [3, "spades"]])
    @dealer.hand.update(cards: [[2, "hearts"], [2, "spades"]])
    expect(@game.conclusion(@game.id)).to eq("The following players win: ben@gmail.com, tom@gmail.com")
  end

  it "can have a conclusion where no one wins" do
    @ben.hand.update(cards: [[2, "hearts"], [2, "spades"]])
    @tom.hand.update(cards: [[2, "hearts"], [2, "spades"]])
    @dealer.hand.update(cards: [[2, "hearts"], [2, "spades"]])
    expect(@game.conclusion(@game.id)).to eq("No one wins!")
  end

  it "can return player winner if 21 is drawn" do
    @ben.hand.update(cards: [[10, "hearts"], ["ace", "spades"]])
    expect(@game.find_winner(@ben.hand)).to eq(@ben)
  end

  it "can return dealer winner if player draws over 21" do
    @ben.hand.update(cards: [[10, "hearts"], [10, "spades"], [10, "clubs"]])
    expect(@game.find_winner(@ben.hand)).to eq(@dealer)
  end

  it "can return player winner if dealer draws over 21" do
    @dealer.hand.update(cards: [[10, "hearts"], [10, "spades"], [10, "clubs"]])
    expect(@game.find_winner(@ben.hand)).to eq(@ben)
  end

  it "can check for a 21 hand and create the winner" do
    @ben.hand.update(cards: [[10, "hearts"], ["ace", "spades"]])
    @tom.hand.update(cards: [[2, "hearts"], [2, "spades"]])
    expect(@game.winners.count).to eq(0)
    @game.check_for_winner
    expect(@game.winners.count).to eq(1)
    expect(Player.find(@game.winners[0].player_id)).to eq(@ben)
  end

  it "can return nil if dealer needs to draw again" do
    @ben.hand.update(cards: [[2, "hearts"], [2, "spades"]])
    @tom.hand.update(cards: [[2, "hearts"], [2, "spades"]])
    @dealer.hand.update(cards: [[2, "hearts"], [2, "spades"]])
    expect(@game.dealer_beats_greatest_value_or_reaches_17).to eq(nil)
  end

  it "can return true if dealer doesn't need to draw again" do
    @ben.hand.update(cards: [[2, "hearts"], [2, "spades"]])
    @tom.hand.update(cards: [[2, "hearts"], [2, "spades"]])
    @dealer.hand.update(cards: [[3, "hearts"], [2, "spades"]])
    expect(@game.dealer_beats_greatest_value_or_reaches_17).to eq(true)
  end
end
