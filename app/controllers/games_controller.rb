class GamesController < ApplicationController
  def index
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      @game.players << Player.create(user_id: current_user.id, game_id: @game.id)
      redirect_to game_path(@game.id)
    end
  end

  def show
    @game = Game.find(params[:id])
  end

  private
  def game_params
    params.require(:game).permit(:host, :message)
  end
end
