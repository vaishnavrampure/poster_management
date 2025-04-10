class User < ApplicationRecord
  has_secure_password

  belongs_to :client_company, optional: true
  belongs_to :role, optional: true

  validates :name, :email, presence: true
  validates :email, uniqueness: true

  delegate :permissions, to: :role, allow_nil: true

  def has_permission?(perm_name)
    role&.permissions&.exists?(name: perm_name) || false
  end
  def admin?
    role&.name == "admin"
  end

  def client?
    role&.name == "client"
  end

  def contractor?
    role&.name == "contractor"
  end

  def employee?
    role&.name == "employee"
  end
end
