module PlayersHelper
  def display_cards_for(player)
    player.cards.map do |card|
      display_card(card)
    end.join("").html_safe
  end

  def display_card(card)
    svg "#{card[0]}_of_#{card[1]}"
  end

  def human_players(game)
    game.players.where.not(user: nil)
  end

  def svg(name)
    content_tag(:object, nil, data: asset_url("svg/#{name}.svg"), type: "image/svg+xml")
  end
end
