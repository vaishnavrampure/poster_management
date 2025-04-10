# Define all permissions grouped by area
PERMISSIONS = {
  users: %w[
    create:user view:user update:user delete:user
  ],
  client_companies: %w[
    create:client_company view:client_company update:client_company delete:client_company
  ],
  campaigns: %w[
    create:campaign view:campaign update:campaign delete:campaign
    change:campaign_status
    view:campaign_completed view:campaign_in_progress
    assign:campaign
  ],
  images: %w[
    upload:campaign_image view:image delete:image update:image
    approve:image reject:image
  ]
}

# Flatten the list
permission_names = PERMISSIONS.values.flatten.uniq

# Create all permissions
permission_names.each do |perm_name|
  Permission.find_or_create_by!(name: perm_name)
end

# Role -> permissions mapping
ROLE_PERMISSIONS = {
  employee: PERMISSIONS[:users] +
            PERMISSIONS[:client_companies] +
            PERMISSIONS[:campaigns] +
            PERMISSIONS[:images],

  client: [
    "view:campaign", "view:campaign_completed",
    "view:image", "view:client_company"
  ],

  contractor: [
    "upload:campaign_image",
    "view:campaign_in_progress",
    "view:campaign_completed",
    "view:image"
  ]
}

# Assign permissions to each role
ROLE_PERMISSIONS.each do |role, perms|
  users = User.where(role: role.to_s)
  perms.each do |perm_name|
    permission = Permission.find_by!(name: perm_name)
    users.each do |user|
      user.permissions << permission unless user.permissions.include?(permission)
    end
  end
end

puts "✅ Permissions and role assignments completed!"
