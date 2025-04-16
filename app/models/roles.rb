class Role < ApplicationRecord
    has_many :users
    has_many :role_permissions, dependent: :destroy
    has_many :permissions, through: :role_permissions
    belongs_to :user
    belongs_to :campaign, optional: true

    validates :name, presence: true, uniqueness: true
  end
  