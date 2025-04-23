class Campaign < ApplicationRecord
  has_many :images, dependent: :destroy
  has_many :campaign_users, dependent: :destroy
  belongs_to :contractor, class_name: "User"
  belongs_to :client_company
  has_many :roles, dependent: :destroy
  
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
