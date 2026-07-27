# frozen_string_literal: true

class RevertConvertUserGroupsIntoUsers < ActiveRecord::Migration[7.2]
  # We define private classes to avoid depending on the app's models
  # (which may or may not exist depending on module setup).
  class User < ActiveRecord::Base
    self.table_name = "decidim_users"
    self.inheritance_column = nil
    scope :converted_group, -> { where("extended_data @> ?", { group: true }.to_json) }
  end

  # rubocop:disable Rails/SkipsModelValidations
  def up
    User.converted_group.find_each do |group|
      restored_extended_data = (group.extended_data || {}).dup

      # 1. Handle email restoration
      if restored_extended_data["patched"] == true
        previous = restored_extended_data["previous_email"]
        if previous.blank? || previous&.end_with?(".invalid")
          group.update_columns(email: "")
        else
          group.update_columns(email: previous)
        end

        restored_extended_data = restored_extended_data.except("patched", "previous_email")
      end

      if group.officialized_at.present?
        restored_extended_data["verified_at"] = group.officialized_at.iso8601
      end
      restored_extended_data = restored_extended_data.except("group")
      group.update_columns(
        type: "Decidim::GroupUsers::UserGroup",
        extended_data: restored_extended_data,
        officialized_at: nil
      )
    end
  end
  # rubocop:enable Rails/SkipsModelValidations

  def down
    # This migration reverses an upstream migration.
    # Rolling back would re-run the migration, which is not this module's responsibility.
    say "No-op: this migration cannot be rolled back automatically."
  end
end