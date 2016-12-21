class Hand < ApplicationRecord
  belongs_to :player

  serialize :cards

  def value
    @cards = self.cards
    sum = 0
    @cards.each do |card|
      case card[0]
        when "Jack"
          sum +=  10
        when "Queen"
          sum +=  10
        when "King"
          sum +=  10
        when "Ace"
          sum += 11
        else
          sum += card[0]
      end
    end
    sum
  end
end
