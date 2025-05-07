class UserPermission < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :permission
end
