module UserHelper
  def won_games_for(user)
    Game.where(winner: user.id).count
  end
end
