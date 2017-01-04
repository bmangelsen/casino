class GamesController < ApplicationController

  def index
  end

  def create
    @game = Game.new(game_params)
    @game.setup
    if @game.save
      redirect_to game_path(@game.id)
      broadcast("New game has begun!")
    end
  end

  def show
    @game = Game.find(params[:id])
    @player = @game.player_for(current_user)
    @dealer = @game.table.dealer
  end

  private
  def game_params
    params.require(:game).permit(:host, :table_id)
  end

  private
  def broadcast(message)
    @dealer = @game.table.dealer
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
