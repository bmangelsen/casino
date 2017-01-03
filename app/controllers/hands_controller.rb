class HandsController < ApplicationController
  def update
    @hand = Hand.find(params[:id])
    @game = @hand.game
    @player = @game.player(current_user)
    @dealer = @game.dealer

    if @hand.belongs_to_player?(@hand.player_id, current_user)
      @hand.deal
    else
      until @hand.value >= 17 || @hand.value > @player.hand.value
        @hand.deal
      end
      @game.update(drawing_complete: true)
    end

    if (@game.has_winner?(current_user) && @game.drawing_complete == true) || @player.hand.value >= 21
      @game.update(drawing_complete: true)
      if @game.find_winner(current_user) == @player
        @game.update(winner: @player.user_id)
        broadcast("You win! Would you like to play again?")
      elsif @game.find_winner(current_user) == @dealer
        @game.update(winner: "dealer")
        broadcast("You lose! Would you like to play again?")
      else
        @game.update(winner: "no one")
        broadcast("No one wins! Would you like to play again?")
      end
    else
      broadcast("")
    end
  end

  private
  def broadcast(message)
    # @game.human_players.each do |player|
      ActionCable.server.broadcast("game_#{@game.id}", message: message, content: render_to_string(@game))
    # end
  end
end
