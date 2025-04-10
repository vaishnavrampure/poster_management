class DashboardController < ApplicationController
   layout "application"
  before_action :require_login

  def index
    @user = User.find(session[:user_id])
  end

  private

  def require_login
    unless session[:user_id]
      redirect_to login_path, alert: "You must be logged in to access this page."
    end
  end
end
