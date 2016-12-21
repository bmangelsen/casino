class HandsController < ApplicationController
  def update
    @hand = Hand.find_by(id: params[:id])
    @deck = Deck.find_by(game_id: Player.find(@hand.player_id).game_id)
    @game = Game.find(Player.find(@hand.player_id).game_id)
    @hand.cards << @deck.play_card
    @hand.save
    # if @hand.value == 21
    #
    # elsif @hand.value > 21
    #   @game.over
    #   redirect_to game_path(@deck.game_id)
    # else
      redirect_to game_path(@deck.game_id)
    # end
  end
end
