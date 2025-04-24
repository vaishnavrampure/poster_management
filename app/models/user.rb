class User < ApplicationRecord
  has_secure_password

  belongs_to :client_company, optional: true

  has_many :roles
  has_many :contractor_campaigns, -> { where(roles: { name: "contractor" }) }, through: :roles, source: :campaign

  validates :name, :email, presence: true
  validates :email, uniqueness: true
  validates :password, presence: true, on: :create

  def has_permission?(perm_name)
    roles.joins(:permissions).exists?(permissions: { name: perm_name })
  end

  def admin?
    roles.any? { |r| r.name == "admin" }
  end

  def client?
    roles.any? { |r| r.name == "client" }
  end

  def contractor?
    roles.any? { |r| r.name == "contractor" }
  end

  def employee?
    roles.any? { |r| r.name == "employee" }
  end

 def add_contractor_campaign(campaign)
  roles.find_or_initialize_by(name: "contractor", campaign_id: campaign.id).tap do |role|
    role.user_id ||= self.id
    role.save!
  end
end

  def permissions
    roles.includes(:permissions).flat_map(&:permissions).uniq
  end

  def assign_global_role!(role_name)
    roles.where(campaign_id: nil).destroy_all
    role = roles.find_or_create_by!(name: role_name, campaign_id: nil)

    roles_with_permissions = {
      "admin" => %w[
        manage:users
        create:user
        manage:campaigns
        create:campaign
        manage:client_companies
        update:campaign
        update:user
        update:client_companies
        create:client_companies
        view:campaigns
        view:images
        approve:image
        reject:image
        upload:campaign_image
      ],
      "employee" => %w[
        manage:users
        create:user
        delete:user
        delete:campaign
        delete:client_company
        manage:campaigns
        create:campaign
        manage:client_companies
        update:campaign
        update:user
        update:client_companies
        create:client_companies
        view:campaigns
        view:images
        approve:image
        reject:image
      ],
      "client" => %w[
        view:campaigns
        view:images
      ],
      "contractor" => %w[
        view:campaigns
        upload:campaign_image
      ]
    }

   perms = Permission.where(name: roles_with_permissions[role_name])
  role.permissions = []
  role.permissions << perms
  end
end
