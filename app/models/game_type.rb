class GameType < ApplicationRecord
  def activate
    self.update(active: true)
  end

  def deactivate
    self.update(active: false)
  end
end
