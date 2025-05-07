class CampaignUser < ApplicationRecord
  belongs_to :campaign
  belongs_to :user, optional: true
end
