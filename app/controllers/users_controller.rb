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
    @user.client_company_id = params[:user][:client_company_id]

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
    @available_campaigns = Campaign.where(status: "Active")
  end

  def update
    @user = User.find(params[:id])
    @user.assign_attributes(user_params.except(:role, :campaign_ids))
    @user.client_company_id = params[:user][:client_company_id]

    role_name = params[:user][:role] || @user.roles.find_by(campaign_id: nil)&.name
    @user.assign_global_role!(role_name)

    selected_campaign_ids = Array(params[:user][:campaign_ids]).reject(&:blank?).map(&:to_i)

    if role_name.in?(%w[contractor client employee])
      @user.roles.where.not(campaign_id: nil).where(name: role_name).destroy_all

      selected_campaign_ids.each do |campaign_id|
        campaign = Campaign.find_by(id: campaign_id)
        next unless campaign
        if role_name == "client" && campaign.client_company_id != @user.client_company_id
          next
        end

        @user.roles.create!(name: role_name, campaign_id: campaign.id)
      end
    end

    if @user.save
      redirect_to users_path, notice: "User updated"
    else
      @available_campaigns = Campaign.where(status: "Active")
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: 'User deleted successfully.'
  end

  def assign_campaign
    user = User.find(params[:id])
    campaign = Campaign.find_by(id: params[:campaign_id])

    if campaign
      if user.contractor?
        user.add_contractor_campaign(campaign)
      elsif user.client?
        user.update(client_company_id: campaign.client_company_id)
      end

      redirect_to users_path, notice: "Campaign assigned to #{user.name}"
    else
      redirect_to users_path, alert: "Campaign not found."
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :role, :client_company_id, campaign_ids: [])
  end

  def authorize_manage_users
    unless current_user.has_permission?("manage:users")
      redirect_to users_path, alert: "You are not authorized to perform this action."
    end
  end
end
