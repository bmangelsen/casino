class HandsController < ApplicationController
  def update
    @hand = Hand.find_by(id: params[:id])
    @deck = Deck.find_by(game_id: Player.find(@hand.player_id).game_id)
    @game = Game.find(Player.find(@hand.player_id).game_id)
    @hand.cards << @deck.play_card
    @hand.add_card_value(@hand.cards.last)

    if @hand.is_winner?
      @user = User.find(Player.find(@hand.player_id).user_id)
      @user.wins += 1
      @user.save
      @game.over = true
      @game.save
      redirect_to game_path(@game.id), notice: "You won! Would you like to play again?"
    elsif @hand.is_bust?
      @game.over = true
      @game.save
      redirect_to game_path(@game.id), notice: "You busted! Would you like to play again?"
    else
      redirect_to game_path(@game.id)
    end

  end
end
