class HandsController < ApplicationController
  def update
    @hand = Hand.find_by(id: params[:id])
    @deck = Deck.find_by(game_id: Player.find(@hand.player_id).game_id)
    @hand.cards << @deck.play_card
    @hand.save
    redirect_to game_path(@deck.game_id)
  end
end
