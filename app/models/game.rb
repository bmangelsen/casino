class Game < ApplicationRecord
  has_many :player_games
  has_many :players, through: :player_games
  has_many :hands
  has_one :deck
  has_many :winners
  belongs_to :table

  # serialize :winner, Array

  def setup #put save before creating game players to get rid of own_id_to_players method
    self.build_deck
    self.add_players
    self.players.update(turn_over: false)
    self.create_player_hands
    save
    self.add_own_id_to_players
    self.next_players_turn
  end

  def next_players_turn
    if self.players_that_have_not_had_turn.count > 0
      self.update(current_turn_player: self.players_that_have_not_had_turn.first.id)
    else
      false
    end
  end

  def players_that_have_not_had_turn
    human_players.where(game_id: self.id, turn_over: false)
  end

  def create_player_hands
    players.each do |player|
      player.create_hand(self.deck)
    end
  end

  def player_for(user)
    players.find_by(user: user)
  end

  def add_players
    self.players = table.players
  end

  def human_players
    players.where.not(user: nil)
  end

  def add_own_id_to_players
    self.players.each do |player|
      player.update(game_id: self.id)
    end
  end

  def dealer_hand_value
    dealer.hand.value
  end

  def dealer
    Player.find_by(user_id: nil, game_id: self.id)
  end

  def human_players
    players.where.not(user: nil)
  end

  def other_human_players(current_player)
    human_players.where.not(id: current_player.id)
  end

  def find_winner(hand)
    if hand.value == 21
      hand.player
    elsif hand.value > 21
      dealer
    elsif dealer_hand_value > 21
      hand.player
    elsif hand.value > dealer_hand_value
      hand.player
    else
      dealer
    end
  end

  def tie_game?(player)
    player.hand.value == dealer_hand_value
  end

  def conclusion(id)
    @game = Game.find(id)
    results = []
    ties = []
    @game.human_players.each do |player|
      if !tie_game?(player)
        @game.winners.create(game_id: @game.id, player_id: @game.find_winner(player.hand).id)
        @game.save
      else
        ties << player.id
      end
    end

    @game.remove_duplicate_winners

    @game.winners.each do |winner|
      if user = Player.find(winner.player_id).user
        results << user.email
      end
    end

    results.uniq!

    if (human_players.count == ties.count) || (ties.count > 0 && results.count == 0)
      "No one wins!"
    elsif results.count == 0
      "Dealer wins!"
    else
      "The following players win: " + results.join(", ")
    end
  end

  def remove_duplicate_winners
    duplicates = find_duplicate_winners
    duplicates.each do |duplicate|
      Winner.find_by(game_id: duplicate.game_id, player_id: duplicate.player_id).destroy
    end
  end

  def find_duplicate_winners
    Winner.select(:game_id, :player_id).group(:game_id, :player_id).having("count(*) > 1")
  end

  def check_for_winner
    human_players.each do |player|
      if player.hand.value == 21
        self.winners.create(game_id: self.id, player_id: player.id)
        self.save
        player.update(turn_over: true)
      end
    end
  end

  def greatest_player_value
    value = 0
    self.human_players.each do |player|
      if player.hand.value > value && player.hand.value < 21
        value = player.hand.value
      end
    end
    value
  end

  def dealer_beats_greatest_value_or_reaches_17
    if dealer_hand_value >= 17 || dealer_hand_value > greatest_player_value
      true
    end
  end
end
