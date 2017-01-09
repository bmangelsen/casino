module UserHelper
  def won_games_for(user)
    @wins = []
    Player.where(user_id: user.id).each do |player|
      if winner(player).count > 0
        @wins << winner(player)
      end
    end
    @wins.count
  end

  def winner(player)
    Winner.where(player_id: player.id)
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
