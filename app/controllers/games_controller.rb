class GamesController < ApplicationController

  def index
  end

  def show
    @game = Game.find(params[:id])
    @player = @game.player(current_user)
    @dealer = @game.dealer
    if @game.has_winner?(current_user)
      if @game.find_winner(current_user) == @player
        @game.update(winner: @player.user_id)
        @game.update(drawing_complete: true)
        flash[:notice] = "You win! Would you like to play again?"
      end
    end
  end

  private
  def game_params
    params.require(:game).permit(:host, :table_id)
  end

  private
  def broadcast(message)
    @player = @game.player(current_user)
    @dealer = @game.dealer
    ActionCable.server.broadcast("game_#{@game.id}", message: message, content: render_to_string(@game))
  end
end
