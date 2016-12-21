class DecksController < ApplicationController
  def create
    @deck = Deck.new(deck_params)
    @deck.build_deck
    if @deck.save
      @card = @deck.play_card
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
