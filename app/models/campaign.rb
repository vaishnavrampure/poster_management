class Campaign < ApplicationRecord
  has_many :images, dependent: :destroy
  has_many :campaign_users, dependent: :destroy
  belongs_to :client, class_name: "User", optional: true
  
  validates :name, :status, presence: true
  validates :status, inclusion: { in: ["Active", "Pending", "Completed"] }

  def pending?
    status == "Pending"
  end

  def active?
    status == "Active"
  end

  def completed?
    status == "Completed"
  end
end
