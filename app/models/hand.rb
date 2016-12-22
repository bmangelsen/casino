class Hand < ApplicationRecord
  belongs_to :player

  serialize :cards

  def sum_all_cards
    self.cards.each do |card|
      add_card_value(card)
    end
  end

  def add_card_value(card)
    case card[0]
      when "Jack"
        self.value += 10
      when "Queen"
        self.value += 10
      when "King"
        self.value += 10
      when "Ace"
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
