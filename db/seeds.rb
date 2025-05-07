permission_names = %w[
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

]

permissions = permission_names.map do |name|
  Permission.find_or_create_by!(name: name)
end

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

roles_with_permissions.each do |role_name, perm_names|
  # ✅ These are global roles (not tied to a specific campaign)
  role = Role.find_or_create_by!(name: role_name, campaign_id: nil)
  role.permissions = Permission.where(name: perm_names)
end
