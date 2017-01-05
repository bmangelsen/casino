class HandsController < ApplicationController
  def update
    @hand = Hand.find(params[:id])
    @game = @hand.game
    @table = @game.table
    @player = @game.player_for(current_user)
    @dealer = @game.dealer

    if params[:stand]
      @player.update(turn_over: true)
      if @game.next_players_turn
        broadcast("#{Player.find(@game.current_turn_player).email}'s turn now!", "game_refresh")
      else
        until @game.dealer_beats_greatest_value_or_reaches_17
          @dealer.hand.deal
        end
        @game.update(over: true)
        broadcast("#{@game.conclusion}", "game_refresh")
      end
    else
      if @hand.belongs_to_player?(@hand.player_id, current_user)
        @hand.deal
      else
        until @hand.value >= 17 || @hand.value > @player.hand.value
          @hand.deal
        end
        @game.update(over: true)
      end

      if @hand.bust?
        @hand.player.update(turn_over: true)
        if @game.next_players_turn
          broadcast("Busted! #{Player.find(@game.current_turn_player).email}'s turn", "game_refresh")
        else
          broadcast("Busted! #{@game.conclusion}", "game_refresh")
        end
      else
        if @hand.value == 21
          @game.check_for_winner
          if @game.next_players_turn
            broadcast("21! #{Player.find(@game.current_turn_player).email}'s turn", "game_refresh")
          else
            broadcast("#{@game.conclusion}", "game_refresh")
          end
        else
          broadcast("", "game_refresh")
        end
      end
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
