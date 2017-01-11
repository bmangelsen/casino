class TablesController < ApplicationController
  def join_table
    @table = Table.find_table
    @table.add_player(current_user)
    if @table.games.any?
      flash[:notice] = "Table found! Waiting for game in progress to conclude..."
      redirect_to waiting_path(@table.id)
      broadcast("#{current_user.email} has joined the table! They will join on the next game.", "game_refresh")
    else
      @game = Game.new(table: @table, host: current_user.id)
      @game.setup
      @game.check_for_winner
      if @game.winners.count > 0
        @game.update(over: true)
        flash[:notice] = "Win on the draw! Lucky!"
        redirect_to game_path(@game.id)
        broadcast("#{@game.conclusion(@game.id)}", "game_refresh")
      else
        redirect_to game_path(@game.id)
      end
    end
  end

  def leave_table
    @table = Table.find(params[:id])
    @player = Player.find_by(user_id: current_user.id, table_id: @table.id)
    @user = User.find(current_user.id)
    @game = Game.find(@player.game_id)
    if @game.over
      @table.players.delete(@player)
    else
      @game.players.delete(@player)
      @table.players.delete(@player)
    end
    if @table.players.count == 1
      Table.delete(@table.id)
    else
      if @game.players.count == 1
        @game = Game.new(table: @table, host: @table.human_players[0].user.id)
        @game.setup
        @game.check_for_winner
        if @game.winners.count > 0
          @game.update(over: true)
          broadcast("#{@game.conclusion(@game.id)}", "new_game")
        end
        broadcast("", "new_game")
      else
        if @game.host == @user.id
          if @game.next_players_turn
            @game.update(host: Player.find(@game.current_turn_player).user.id)
            broadcast("#{@player.email} has left the table", "game_refresh")
          else
            @game.update(host: Player.find(@game.other_human_players(@user)[0].id).user.id)
            broadcast("#{@game.conclusion(@game.id)}", "game_refresh")
          end
        else
          if @game.next_players_turn
            broadcast("#{@player.email} has left the table", "game_refresh")
          else
            @game.update(over: true)
            broadcast("#{@game.conclusion(@game.id)}", "game_refresh")
          end
        end
      end
    end
    redirect_to games_path
  end

  def waiting
    @table = Table.find(params[:id])
    @game = @table.games.last
  end

  def broadcast(message, event)
    @game = @table.games.last
    @dealer = @game.dealer
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


# TableChannel.broadcast_to("table_#{@table.id}", message: message, content: render_to_string(@game, locals: { player: Player.find_by(table_id: @table.id, user_id: current_user.id), dealer: @dealer, game: @game }))
