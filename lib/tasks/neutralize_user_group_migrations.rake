# frozen_string_literal: true

# lib/tasks/neutralize_user_group_migrations.rake
#
# Decidim v0.32 ships three migrations that remove all user-group infrastructure:
#   - RemoveUserGroupCore          (drops columns from coauthorships & likes)
#   - RemoveUserGroupMemberships   (drops decidim_user_group_memberships table)
#   - RemoveUserGroupOrganizations (drops user_groups_enabled from organizations)
#
# Our module still needs those tables/columns so users can comment as a group.
# This task rewrites the copied migration files as no-ops: Rails records them as
# "run" in schema_migrations but nothing destructive happens.
#
# Usage:
#   1. rails decidim:install:migrations   (copies engine migrations into db/migrate/)
#   2. rails decidim_group_users:neutralize_user_group_migrations
#   3. rails db:migrate

namespace :decidim_group_users do
  desc "Rewrite Decidim v0.32 user-group removal migrations as no-ops"
  task neutralize_user_group_migrations: :environment do
    migrations_to_neutralize = {
      "RemoveUserGroupCore" => "7.0",
      "RemoveUserGroupMemberships" => "7.0",
      "RemoveUserGroupOrganizations" => "7.0",
      "RemoveUserGroupComments" => "7.0"
    }

    migrations_dir = Rails.root.join("db/migrate")

    puts "Neutralizing user-group removal migrations in #{migrations_dir} ..."
    puts

    migrations_to_neutralize.each do |class_name, rails_version|
      snake_name = class_name.gsub(/([a-z])([A-Z])/, '\1_\2').downcase
      files = Dir.glob(migrations_dir.join("*_#{snake_name}{,.*}.rb"))

      if files.empty?
        puts "  [SKIP] #{class_name} — not found in db/migrate/ (not yet copied?)"
        next
      end

      files.each do |file|
        content = File.read(file)

        # Already neutralized? (empty class body)
        if content.match?(/class\s+#{class_name}\s*<.*Migration.*\n\s*end/m) &&
           content.exclude?("def up")
          puts "  [OK]   #{class_name} — already a no-op"
          next
        end

        replacement = <<~RUBY
          # frozen_string_literal: true

          # Neutralized by decidim-group_users.
          # User groups are still in use for commenting; the original migration
          # would have dropped the tables/columns this module depends on.
          class #{class_name} < ActiveRecord::Migration[#{rails_version}]
          end
        RUBY

        File.write(file, replacement)
        puts "  [DONE] #{class_name} — neutralized (#{File.basename(file)})"
      end
    end

    puts
    puts "Done. You can now run `rails db:migrate` safely."
  end
end
