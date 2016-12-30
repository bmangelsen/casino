class HandsController < ApplicationController
  def update
    @hand = Hand.find(params[:id])
    @game = @hand.game
    if @hand.belongs_to_player?(@hand.player_id, current_user)
      @hand.deal
    else
      until @hand.value >= 17
        @hand.deal
      end
      @game.update(drawing_complete: true)
    end
    redirect_to game_path(@game.id)
  end
end
