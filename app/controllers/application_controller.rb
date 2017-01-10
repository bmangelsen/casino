class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authorize
    redirect_to games_path unless current_user
  end

  def authorize_admin
    redirect_to games_path unless current_user.admin == true
  end
end
