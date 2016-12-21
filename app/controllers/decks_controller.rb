class DecksController < ApplicationController
  def create
    @deck = Deck.new(deck_params)
    @deck.build_deck
    if @deck.save
      player = Player.find_by(user_id: current_user.id, game_id: @deck.game_id)
      dealer = Player.find_by(user_id: nil, game_id: @deck.game_id)
      player.hand = Hand.create(cards: [@deck.play_card, @deck.play_card])
      dealer.hand = Hand.create(cards: [@deck.play_card, @deck.play_card])
      redirect_to game_path(id: @deck.game_id)
    end
  end

  def update
  end

  private
  def deck_params
    params.require(:deck).permit(:game_id)
  end
end
