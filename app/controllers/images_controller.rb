class ImagesController < ApplicationController
  before_action :require_login
  before_action :set_campaign, except: [:moderation_queue, :moderation_history, :approve, :reject]

  def index
    @images = @campaign.images
  end

  def new
    @image = @campaign.images.new
  end

  def create
    @image = @campaign.images.new(image_params)
    @image.status = "pending"

    if @image.save
      redirect_to campaign_images_path(@campaign), notice: 'Image uploaded successfully'
    else
      render :new
    end
  end

  def moderation_queue
    @images = Image.where(status: "pending")
  end

  def moderation_history
    if current_user.client?
      company_id = current_user.client_company_id
      @images = Image.joins(:campaign).where(
        status: ["approved", "rejected"],
        campaigns: { client_company_id: company_id }
      )
    elsif current_user.contractor?
      @images = Image.where(
        status: ["approved", "rejected"],
        campaign_id: current_user.contractor_campaign_ids
      )
    else
      @images = Image.where(status: ["approved", "rejected"])
    end
  end

  def approve
    @image = Image.find(params[:id])
    authorize_action!("approve:image")
  
    @image.update(status: "approved", rejection_reason: nil)
    redirect_back fallback_location: dashboard_path, notice: "Image approved."
  end
  
  def reject
    @image = Image.find(params[:id])
    authorize_action!("reject:image")
  
    rejection_reason = nil # or params[:rejection_reason].presence if you later add it
  
    if @image.update(status: "rejected", rejection_reason: rejection_reason)
      notice_msg = "Image rejected."
      redirect_back fallback_location: dashboard_path, notice: notice_msg
    else
      redirect_back fallback_location: dashboard_path, alert: "Failed to reject image."
    end
  end
  
  private
  
def authorize_action!(perm)
  return if current_user.has_permission?(perm)

  redirect_back fallback_location: root_path, alert: "Not authorized." and return
end
  

  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to campaigns_path, alert: "Campaign not found"
  end

  def image_params
    params.require(:image).permit(:contractor_id, :file)
  end
  
  def authorize_moderation_view
    unless current_user.has_permission?("approve:image") ||
           current_user.has_permission?("reject:image") ||
           current_user.contractor? ||
           current_user.client?
      redirect_to dashboard_path, alert: "You are not authorized to view moderation."
    end
  end
end
