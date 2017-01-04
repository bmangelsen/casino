module UserHelper
  def won_games_for(user)
    Game.where(winner: user.id).count
  end

  def total_games_for(user)

  end

  def find_users
    User.where(admin: false)
  end

  def count_users
    find_users.count
  end

  def display_user_emails
    find_users.map do |user|
      user.email
    end
  end
end
