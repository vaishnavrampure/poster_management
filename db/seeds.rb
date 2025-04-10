# Define all permissions used in the app
permission_names = %w[
  manage:users
  manage:campaigns
  view:campaigns
  update:campaign
  update:user
  update:client_companies
  manage:client_companies
  view:images
  approve:image
  reject:image
  upload:campaign_image
]

permissions = permission_names.map do |name|
  Permission.find_or_create_by!(name: name)
end

# Roles with associated permissions (admin left unchanged)
roles_with_permissions = {
  "admin" => %w[
    manage:users
    manage:campaigns
    manage:client_companies
    update:campaign
    update:user
    update:client_companies
    view:campaigns
    view:images
    approve:image
    reject:image
    upload:campaign_image
  ],

  "employee" => %w[
    manage:campaigns
    view:campaigns
    view:images
    upload:campaign_image
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

roles_with_permissions.each do |role_name, perm_names|
  role = Role.find_or_create_by!(name: role_name)
  role.permissions = Permission.where(name: perm_names)
end
