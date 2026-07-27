# frozen_string_literal: true


module Decidim
  module GroupUsers
    class UserGroup < UserBaseEntity
      has_many :memberships, 
               class_name: "Decidim::GroupUsers::UserGroupMembership",
               foreign_key: :decidim_user_group_id
      has_many :users, through: :memberships
      
      scope :verified, -> { where.not(officialized_at: nil) }

      def deleted?
        deleted_at.present?
      end

      def presenter
        Decidim::UserGroupPresenter.new(self)
      end
    end
  end
end