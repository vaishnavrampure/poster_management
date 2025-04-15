class UsersController < ApplicationController
  before_action :require_login
  before_action :authorize_manage_users, only: [:new, :create, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: 'User created successfully.'
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_path, notice: "User updated successfully!"
    else
      render :edit, alert: "Failed to update user."
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: 'User deleted successfully.'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :role_id)
  end
  
  

  def authorize_manage_users
    unless current_user.has_permission?("manage:users")
      redirect_to users_path, alert: "You are not authorized to perform this action."
    end
  end
end
