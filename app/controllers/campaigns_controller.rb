class CampaignsController < ApplicationController
  before_action :require_login  
  before_action :set_campaign, only: [:show, :edit, :update, :destroy]

  def index
    if current_user.client?
      @campaigns = Campaign.where(client_company_id: current_user.client_company_id)
                           .where("status = ? OR (status = ? AND updated_at >= ?)", "Active", "Completed", 1.month.ago)
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
      redirect_to campaigns_path, alert: "You are not authorized to view this campaign." unless @campaign
    else
      @campaign = Campaign.find(params[:id])
    end
  end
  

  def campaign_params
    params.require(:campaign).permit(:name, :status, :client_company_id)
  end
end
