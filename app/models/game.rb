class Game < ApplicationRecord
  has_many :player_games
  has_many :players, through: :player_games
  has_many :hands
  has_one :deck
  belongs_to :table

  serialize :winner, Array

  def setup
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

  def player_has_hand(current_user)
    player(current_user).hand if player(current_user)
  end

  def player_hand_value(current_user)
    player(current_user).hand.value if player_has_hand(current_user)
  end

  def player(current_user)
    Player.find_by(user_id: current_user.id, game_id: self.id)
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

  def has_winner?(current_user)
    if player_has_hand(current_user)
      if player_hand_value(current_user) >= 21 || dealer_hand_value >= 21 || self.over == true
        true
      end
    end
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
    elsif hand.value == dealer_hand_value
      nil
    else
      dealer
    end
  end

  def conclusion
    self.update(over: true)
    results = []
    self.human_players.each do |player|
      self.winner << self.find_winner(player.hand)
      self.save
    end

    self.winner.uniq!

    self.winner.each do |winner|
      if winner && winner.user_id
        results << winner.email
      end
    end

    if results.size == 0
      "Dealer wins!"
    else
      "The following players win: " + results.join(", ")
    end
  end

  def check_for_winner
    human_players.each do |player|
      if player.hand.value == 21
        self.winner << player
        player.update(turn_over: true)
      end
    end
  end

  def greatest_player_value
    value = 0
    self.human_players.each do |player|
      if player.hand.value > value
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
