class GamesController < ApplicationController
  def index
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      @game.players << Player.create(user_id: current_user.id, game_id: @game.id)
      @game.players << Player.create(game_id: @game.id)
      redirect_to game_path(@game.id)
    end
  end

  def show
    @game = Game.find(params[:id])
    @player = Player.find_by(user_id: current_user.id, game_id: @game.id)
    @dealer = Player.find_by(user_id: nil, game_id: @game.id)
  end

  private
  def game_params
    params.require(:game).permit(:host)
  end
end
