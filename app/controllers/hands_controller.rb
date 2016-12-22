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

  def dealer_update
    @dealer_hand = Hand.find_by(id: params[:dealer_hand_id])
    @player_hand = Hand.find_by(id: params[:player_hand_id])
    @deck = Deck.find_by(game_id: Player.find(@dealer_hand.player_id).game_id)
    @game = Game.find(Player.find(@dealer_hand.player_id).game_id)

    until @dealer_hand.value > 17
      @dealer_hand.cards << @deck.play_card
      @dealer_hand.add_card_value(@dealer_hand.cards.last)
    end

    if @dealer_hand.is_winner?
      @game.over = true
      @game.save
      redirect_to game_path(@game.id), notice: "Dealer won! Would you like to play again?"
    elsif @dealer_hand.is_bust?
      @player = User.find(Player.find(@player_hand.player_id).user_id)
      @player.wins += 1
      @player.save
      @game.over = true
      @game.save
      redirect_to game_path(@game.id), notice: "Dealer busted! You win!"
    else
      if @dealer_hand.value > @player_hand.value
        @game.over = true
        @game.save
        redirect_to game_path(@game.id), notice: "Dealer won! Would you like to play again?"
      elsif @player_hand.value > @dealer_hand.value
        @player = User.find(Player.find(@player_hand.player_id).user_id)
        @player.wins += 1
        @player.save
        @game.over = true
        @game.save
        redirect_to game_path(@game.id), notice: "Dealer busted! You win!"
      else
        @game.over = true
        @game.save
        redirect_to game_path(@game.id), notice: "It's a tie! Would you like to play again?"
      end
    end
  end
end
