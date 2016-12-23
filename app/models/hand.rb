class Hand < ApplicationRecord
  belongs_to :player

  serialize :cards

  def sum_all_cards
    self.value = 0
    self.cards.each do |card|
      # if card[0] == "ace"
      #   self.cards.insert(self.cards.length-1, card)
      # end
        add_card_value(card)
    end
  end

  def deck
    Deck.find_by(game_id: Player.find(self.player_id).game_id)
  end

  def game
    Game.find(Player.find(self.player_id).game_id)
  end

  def user
    User.find(Player.find(self.player_id).user_id)
  end

  def deal
    self.cards << player.game.deck.play_card
    self.sum_all_cards
  end

  def add_card_value(card)
    case card[0]
      when "jack"
        self.value += 10
      when "queen"
        self.value += 10
      when "king"
        self.value += 10
      when "ace"
        if self.value + 11 <= 21
          self.value += 11
        else
          self.value += 1
        end
      else
        self.value += card[0]
    end
    save
  end

  def is_winner?
    if self.value == 21
      self.game.update(over: true)
      true
    else
      false
    end
  end

  def is_bust?
    if self.value > 21
      true
    else
      false
    end
  end
end
