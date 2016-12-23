class HandsController < ApplicationController
  def update
    @hand = Hand.find_by(id: params[:id])
    @hand.deal

    if @hand.is_winner?
      @hand.deck.player_winner(@hand)
      redirect_to game_path(@hand.game.id), notice: "You won! Would you like to play again?"
    elsif @hand.is_bust?
      @hand.game.update(over: true)
      redirect_to game_path(@hand.game.id), notice: "You busted! Would you like to play again?"
    else
      redirect_to game_path(@hand.game.id)
    end
  end

  def dealer_update
    @dealer_hand = Hand.find_by(id: params[:dealer_hand_id])
    @player_hand = Hand.find_by(id: params[:player_hand_id])
    @game = @dealer_hand.game

    until @dealer_hand.value >= 17
      @dealer_hand.deal
    end

    if @dealer_hand.is_winner?
      redirect_to game_path(@game.id), notice: "Dealer won! Would you like to play again?"
    elsif @dealer_hand.is_bust?
      @player_hand.deck.player_winner(@player_hand)
      redirect_to game_path(@game.id), notice: "Dealer busted! You win!"
    else
      if @dealer_hand.value > @player_hand.value
        @game.update(over: true)
        redirect_to game_path(@game.id), notice: "Dealer won! Would you like to play again?"
      elsif @player_hand.value > @dealer_hand.value
        @player_hand.deck.player_winner(@player_hand)
        redirect_to game_path(@game.id), notice: "Dealer lost! You win!"
      else
        @game.update(over: true)
        redirect_to game_path(@game.id), notice: "It's a tie! Would you like to play again?"
      end
    end
  end
end
