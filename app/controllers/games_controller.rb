class GamesController < ApplicationController

  def index
  end

  def create
    @game = Game.new(game_params)
    flash[:notice] = nil
    if @game.save
      @deck = @game.create_deck
      human = @game.add_player(current_user)
      computer = @game.add_dealer
      human.create_hand(@deck)
      computer.create_hand(@deck)
      redirect_to game_path(@game.id)
    end
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

  def join_game
    @game = Game.find_by(winner: nil)
    if @game
      if @game.host == current_user.id
        flash[:notice] = "Looks like you started this game, welcome back!"
      else
        human = @game.add_player(current_user)
        human.create_hand(@game.deck)
        human.hand.cards.clear
        human.hand.save
        flash[:notice] = "Welcome! Please wait until current game concludes."
      end
      redirect_to game_path(@game)
    else
      redirect_to root_path
      flash[:notice] = "No active games! Try creating one"
    end
  end

  private
  def game_params
    params.require(:game).permit(:host)
  end

  private
  def broadcast(message)
    ActionCable.server.broadcast("game_#{@game.id}", message: message, content: render_to_string(@game))
  end
end
