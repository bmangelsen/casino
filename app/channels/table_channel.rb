# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class TableChannel < ApplicationCable::Channel
  def subscribed
    table = Table.find(params[:id])
    stream_for "table_#{table.id}"
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
