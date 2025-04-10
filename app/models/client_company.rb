class ClientCompany < ApplicationRecord
    has_many :users
    has_many :campaigns
  
    validates :name, presence: true
  end
  