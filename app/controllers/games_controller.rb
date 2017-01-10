class GamesController < ApplicationController
  before_action :authorize, except: [:index]
  include UserHelper
  def index
  end

  def create
    @game = Game.new(game_params)
    @game.setup
    if @game.save
      redirect_to game_path(@game.id)
      @game.check_for_winner
      if @game.winners.count > 0 && @game.current_turn_player == Player.find_by(user: current_user, game_id: @game.id).id
        # flash[:notice] = "Win on the draw! Lucky!"
        if @game.next_players_turn
          broadcast("", "new_game")
        else
          @game.update(over: true)
          broadcast("#{@game.conclusion(@game.id)}", "game_refresh")
        end
      else
        broadcast("", "new_game")
      end
    end
  end

  def show
    @game = Game.find(params[:id])
    @player = @game.player_for(current_user)
    @dealer = @game.dealer
  end

  def leaderboard
    # @users = User.all
    # @wins = []
    # User.all.each do |user|
    #   @wins << won_games_for(user) if won_games_for(user) > 0
    # end
    # binding.pry
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
