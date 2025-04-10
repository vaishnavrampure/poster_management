class ImagesController < ApplicationController
  before_action :require_login
  before_action :set_campaign, except: [:moderation_queue, :moderation_history, :approve, :reject]
  before_action :authorize_moderation, only: [:moderation_queue, :moderation_history, :approve, :reject]
  
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
    @images = Image.where(status: ["approved", "rejected"])
  end

  def approve
    image = Image.find(params[:id])
    image.update!(status: "approved")
    redirect_to moderation_queue_images_path, notice: "Image approved."
  end
  
  def reject
    image = Image.find(params[:id])
    image.update!(status: "rejected", rejection_note: params[:rejection_note])
    redirect_to moderation_queue_images_path, notice: "Image rejected."
  end

  private

  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to campaigns_path, alert: "Campaign not found"
  end

  def image_params
    params.require(:image).permit(:contractor_id, :file)
  end

  def authorize_moderation
    unless current_user.has_permission?("approve:image") || current_user.has_permission?("reject:image")
      redirect_to dashboard_path, alert: "You are not authorized to moderate images."
    end
  end
end
