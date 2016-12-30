class Hand < ApplicationRecord
  belongs_to :player
  belongs_to :game

  serialize :cards

  def belongs_to_player?(player_id, current_user)
    if Player.find_by(id: player_id, user_id: current_user.id)
      true
    else
      false
    end
  end

  def deal
    self.cards << player.game.deck.play_card
    self.save
  end

  def value
    ace_cards = cards.select { |e|  e.include?("ace") }
    total = sum_array_of_cards(cards)
    ace_cards.each do |c|
      total -= 10 if total > 21
    end
    total
  end

  def sum_array_of_cards(cards)
    cards.reduce(0) {|acc, e| acc + add_card_value(e) }
  end

  def add_card_value(card)
    case card[0]
      when "jack"
        10
      when "queen"
        10
      when "king"
        10
      when "ace"
        11
      else
        card[0]
    end
  end
end
