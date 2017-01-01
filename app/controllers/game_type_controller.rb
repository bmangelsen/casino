class GameTypeController < ApplicationController
  def activate
    type = GameType.find(params[:id])
    type.activate
    redirect_to admin_view_path
  end

  def deactivate
    type = GameType.find(params[:id])
    type.deactivate
    redirect_to admin_view_path
  end
end
