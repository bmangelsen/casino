class TablesController < ApplicationController
  def join_table
    @table = Table.find_table
    @table.add_player(current_user)
    if @table.games.any?
      flash[:notice] = "Table found! Waiting for game in progress to conclude..."
      # redirect_to game_path(@table.games.last.id)
      # add event listener for the contents of a div? C'EST POSSIBLE?!
      broadcast("#{current_user.email} has joined the game!")
    else
      @game = Game.new(table: @table, host: current_user.id)
      @game.setup
      redirect_to game_path(@game.id)
    end
  end

  def leave_table
    @table = Table.find(params[:id])
    @player = Player.find_by(user_id: current_user.id, table_id: @table.id)
    @player.update(table_id: nil)
    if @table.players.count == 1
      Table.delete(@table.id)
    end
    redirect_to games_path
  end

  def broadcast(message)
    @game = @table.games.last
    @dealer = @table.dealer
    @game.human_players.each do |player|
      PlayerChannel.broadcast_to(
        player.user,
        event: 'game_refresh',
        message: message,
        content: render_to_string(@game, locals: { current_player: player, dealer: @dealer, game: @game }
        )
      )
    end
  end
end


# TableChannel.broadcast_to("table_#{@table.id}", message: message, content: render_to_string(@game, locals: { player: Player.find_by(table_id: @table.id, user_id: current_user.id), dealer: @dealer, game: @game }))
