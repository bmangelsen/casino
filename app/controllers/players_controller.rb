class PlayersController < ApplicationController
  def create
    @player = Player.new(player_params)

    if @player.save

    else
      redirect_to root_path
    end
  end

  private
  def player_params
    params.require(:player).permit(:game_id, :user_id)
  end
end
