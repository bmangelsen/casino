class Player < ApplicationRecord
  belongs_to :game
  belongs_to :user
  has_one :hand

  validates :game_id, presence: true

  def cards
    self.hand.cards
  end

  def svg(name)
    file_path = "#{Rails.root}/public/images/svg/#{name}.svg"
    return File.read(file_path).html_safe if File.exists?(file_path)
    '(not found)'
  end
end
