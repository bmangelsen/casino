class GamesController < ApplicationController
  def index
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      @game.add_player(current_user)
      @game.add_dealer
      redirect_to game_path(@game.id)
    end
  end

  def show
    @game = Game.find(params[:id])
    @player = @game.player(current_user)
    @dealer = @game.dealer
  end

  private
  def game_params
    params.require(:game).permit(:host)
  end
end
