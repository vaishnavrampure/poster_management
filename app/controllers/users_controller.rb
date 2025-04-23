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
    @user = User.new(user_params.except(:role, :campaign_id))
  
    if @user.save
      @user.assign_global_role!(params[:user][:role])
  
      if params[:user][:role] == "contractor" && params[:user][:campaign_id].present?
        campaign = Campaign.find_by(id: params[:user][:campaign_id])
        @user.add_contractor_campaign(campaign) if campaign
      end
  
      redirect_to users_path, notice: "User created successfully."
    else
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
  
    if @user.update(user_params.except(:role)) # exclude role from direct mass-assignment
      if params[:user][:role].present?
        @user.assign_global_role!(params[:user][:role]) # reassign the role cleanly
      end
      redirect_to users_path, notice: "User updated"
    else
      render :index
    end
  end
  

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: 'User deleted successfully.'
  end
  def assign_campaign
    user = User.find(params[:id])
    campaign = Campaign.find(params[:campaign_id])
  
    if user.contractor?
      user.add_contractor_campaign(campaign)
    elsif user.client?
      # Optional logic if client has to "follow" campaigns
      user.update(client_company_id: campaign.client_company_id)
    end
  
    redirect_to users_path, notice: "Campaign assigned to #{user.name}"
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :role, :campaign_id)
  end
  
  

  def authorize_manage_users
    unless current_user.has_permission?("manage:users")
      redirect_to users_path, alert: "You are not authorized to perform this action."
    end
  end
end
