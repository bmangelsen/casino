class GamesController < ApplicationController

  def index
  end

  def create
    @game = Game.new(game_params)
    @game.setup
    if @game.save
      redirect_to game_path(@game.id)
      @game.check_for_winner
      broadcast("", "new_game")
    end
  end

  def show
    @game = Game.find(params[:id])
    @player = @game.player_for(current_user)
    @dealer = @game.dealer
  end

  private
  def game_params
    params.require(:game).permit(:host, :table_id)
  end

  private
  def broadcast(message, event)
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
