class DecksController < ApplicationController
  def create
    @deck = Deck.new(deck_params)
    @deck.build_deck
    if @deck.save
      player_hand = @deck.create_player_hand(current_user)
      player_hand.sum_all_cards
      dealer_hand = @deck.create_dealer_hand
      dealer_hand.sum_all_cards

      if player_hand.is_winner?
        @deck.player_winner(player_hand)
        redirect_to game_path(@deck.game_id), notice: "You won! Would you like to play again?"
        return
      end

      redirect_to game_path(@deck.game_id)
    end
  end

  def update
  end

  private
  def deck_params
    params.require(:deck).permit(:game_id)
  end
end
