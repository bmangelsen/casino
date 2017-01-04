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
    @player = @game.player(current_user)
    @dealer = @game.dealer
  end

  private
  def game_params
    params.require(:game).permit(:host, :table_id)
  end

  private
  def broadcast(message)
    @player = @game.player(current_user)
    @dealer = @game.dealer
    @game.human_players.each do |player|
      PlayerChannel.broadcast_to(player.user, message: message, content: render_to_string(@game, locals: { player: player, dealer: @dealer, game: @game }))
    end
  end
end
