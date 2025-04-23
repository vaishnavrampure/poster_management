class ClientCompany < ApplicationRecord
    has_many :users
    has_many :campaigns
  
    validates :name, presence: true
    after_initialize :set_default_status, if: :new_record?
    private

    def set_default_status
      self.status ||= "Pending"
    end
  end