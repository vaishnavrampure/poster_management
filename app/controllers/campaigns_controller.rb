class CampaignsController < ApplicationController
  before_action :require_login  
  before_action :set_campaign, only: [:show, :edit, :update, :destroy]

  def index
    if current_user.role == "contractor"
      @campaigns = current_user.contractor_campaigns
    elsif current_user.role == "client"
      @campaigns = Campaign.where(client_id: current_user.id)
    else
      @campaigns = Campaign.all
    end    
  end
  

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.new(campaign_params)
  
   
    @campaign.contractor_id = current_user.id 
  
    
    @campaign.client_company_id = current_user.client_company_id if current_user.client?
  
    if @campaign.save
      redirect_to campaigns_path, notice: "Campaign created successfully"
    else
      flash[:alert] = @campaign.errors.full_messages.to_sentence
      render :new
    end  
  end

   def show
    @campaign = Campaign.find(params[:id])
    @images = @campaign.images 
  end

  def edit
  end

  def update
    if @campaign.update(campaign_params)
      redirect_to campaigns_path, notice: 'Campaign updated successfully'
    else
      render :edit
    end
  end

  def destroy
    @campaign = Campaign.find(params[:id])
    
    if @campaign.destroy
      redirect_to campaigns_path, notice: "Campaign was successfully deleted."
    else
      redirect_to campaign_path(@campaign), alert: "Failed to delete the campaign."
    end
  end
  
  

  private

  def set_campaign
    if current_user.client?
      @campaign = Campaign.find_by(id: params[:id], client_company_id: current_user.client_company_id)
    elsif current_user.contractor?
      @campaign = Campaign.joins(:campaign_users)
                          .where(id: params[:id], campaign_users: { user_id: current_user.id })
                          .first
    else
      @campaign = Campaign.find(params[:id]) # admin/employee
    end
  
  end
  
  

  def campaign_params
    params.require(:campaign).permit(:name, :status, :client_company_id)
  end
end
