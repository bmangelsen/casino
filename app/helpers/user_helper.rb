module UserHelper
  def won_games_for(user)
    Game.where(winner: user.id).count
  end

  def users
    User.where(admin: false)
  end

  def users_count
    users.count
  end

  def display_user_emails
    users.map do |user|
      user.email
    end
  end
end
