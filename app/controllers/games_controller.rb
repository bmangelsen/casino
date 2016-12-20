class GamesController < ApplicationController
  def index
  end

  def create
    @game = Game.new(game_params)
    if @game.save
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
