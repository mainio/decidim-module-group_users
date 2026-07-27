# frozen_string_literal: true


module Decidim
  module GroupUsers
    class UserGroupMembership < Decidim::ApplicationRecord
      self.table_name = "decidim_user_group_memberships"

      belongs_to :user, class_name: "Decidim::User", foreign_key: :decidim_user_id
      belongs_to :user_group, 
                 class_name: "Decidim::GroupUsers::UserGroup",
                 foreign_key: :decidim_user_group_id
    end
  end
end