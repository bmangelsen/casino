module PlayersHelper

  def display_cards_for(player)
    player.cards.map do |card|
      display_card(card)
    end.join("").html_safe
  end

  def display_card(card)
    svg "#{card[0]}_of_#{card[1]}"
  end

  def other_player(game)
    player = game.players.reject {|player| player.user_id == nil || player.user_id == current_user.id }
    player[0]
  end
end
