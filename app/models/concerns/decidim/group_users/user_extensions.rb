# frozen_string_literal: true

module Decidim
  module GroupUsers
    module UserExtensions
      extend ActiveSupport::Concern

      included do
        has_many :group_memberships,
                 class_name: "Decidim::GroupUsers::UserGroupMembership",
                 foreign_key: :decidim_user_id,
                 dependent: :destroy
        has_many :user_groups,
                 through: :group_memberships,
                 source: :user_group
      end
    end
  end
end
