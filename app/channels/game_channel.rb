# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class GameChannel < ApplicationCable::Channel
  def subscribed
    @game = Game.find(params[:id])
    stream_from game
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def start
    Game.find(params[:id])
    ActionCable.server.broadcast 'game',
      message: "New game!",
      host: current_user
    render_new_game
  end

  private def render_new_game
    ApplicationController.render(text: "Hewllo")
  end
end
