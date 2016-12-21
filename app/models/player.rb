class Player < ApplicationRecord
  belongs_to :game
  belongs_to :user
  has_one :hand

  validates :game_id, presence: true
end
