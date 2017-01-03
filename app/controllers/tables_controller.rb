class TablesController < ApplicationController
  def join_table
    @table = Table.find_table
    @table.add_player(current_user)
    if @table.games.any?
      redirect_to game_path(@table.games.last.id)
    else
      @game = Game.new(table: @table)
      @game.setup
      redirect_to game_path(@game.id)
    end
  end

  def destroy
  end
end


          # def join_game
          #   @game = Game.find_by(winner: nil)
          #   if @game
          #     if @game.host == current_user.id
          #       flash[:notice] = "Looks like you started this game, welcome back!"
          #       redirect_to game_path(@game.id)
          #     else
          #       player = @game.add_player(current_user)
          #       player.create_hand(@game.deck)
          #       player.hand.cards.clear
          #       player.hand.save
          #       redirect_to game_path(@game.id)
          #       broadcast("#{player.user.email} has joined the game!")
          #     end
          #   else
          #     redirect_to root_path
          #     flash[:notice] = "No active games! Try creating one"
          #   end
          # end
