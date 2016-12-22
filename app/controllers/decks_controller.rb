class DecksController < ApplicationController
  def create
    @deck = Deck.new(deck_params)
    @deck.build_deck
    if @deck.save
      player = Player.find_by(user_id: current_user.id, game_id: @deck.game_id)
      dealer = Player.find_by(user_id: nil, game_id: @deck.game_id)
      player.hand = Hand.create(cards: [@deck.play_card, @deck.play_card])
      player.hand.sum_all_cards
      dealer.hand = Hand.create(cards: [@deck.play_card, @deck.play_card])
      dealer.hand.sum_all_cards

      if player.hand.is_winner?
        @user = User.find(Player.find(player.hand.player_id).user_id)
        @user.wins += 1
        @user.save
        @game = Game.find(player.game_id)
        @game.over = true
        @game.save
        redirect_to game_path(@game.id), notice: "You won! Would you like to play again?"
        return
      end

      redirect_to game_path(id: @deck.game_id)
    end
  end

  def update
  end

  private
  def deck_params
    params.require(:deck).permit(:game_id)
  end
end
