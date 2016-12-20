class GamesController < ApplicationController
  def create
    @game = Game.new(game_params)
    @game.players << current_user
    if @game.save
      ActionCable.server.broadcast 'game',
        message: @game.message
        host: current_user
      head :ok
    end
  end

  private
  def game_params
    params.require(:game).permit(:host, :message)
  end
end
