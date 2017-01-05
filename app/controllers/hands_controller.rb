class HandsController < ApplicationController
  def update
    @hand = Hand.find(params[:id])
    @game = @hand.game
    @table = @game.table
    @player = @game.player_for(current_user)
    @dealer = @table.dealer

    if @hand.belongs_to_player?(@hand.player_id, current_user)
      @hand.deal
    else
      until @hand.value >= 17 || @hand.value > @player.hand.value
        @hand.deal
      end
      @game.update(over: true)
    end

    if (@table.has_winner?(current_user) && @game.over == true) || @player.hand.value >= 21
      @game.update(over: true)
      if @table.find_winner(current_user) == @player
        @game.update(winner: @player.user_id)
        broadcast("You win! Would you like to play again?", "game_refresh")
      elsif @table.find_winner(current_user) == @dealer
        @game.update(winner: "dealer")
        broadcast("You lose! Would you like to play again?", "game_refresh")
      else
        @game.update(winner: "no one")
        broadcast("No one wins! Would you like to play again?", "game_refresh")
      end
    else
      broadcast("", "game_refresh")
    end
  end

  private
  def broadcast(message, event)
    @game.human_players.each do |player|
      PlayerChannel.broadcast_to(
        player.user,
        event: event,
        message: message,
        content: render_to_string(@game, locals: { current_player: player, dealer: @dealer, game: @game }
        )
      )
    end
  end
end
