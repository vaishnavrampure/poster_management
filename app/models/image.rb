class Image < ApplicationRecord
  belongs_to :campaign
  belongs_to :contractor, class_name: "User", optional: true

  has_one_attached :file
  validates :file, presence:true 
  validates :status, inclusion: { in: %w[pending approved rejected] }
end