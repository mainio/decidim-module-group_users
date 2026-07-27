# frozen_string_literal: true

module Decidim
  module GroupUsers
    module CommentFormCellExtensions
      extend ActiveSupport::Concern

      included do
        def comment_as_id
          "add-comment-#{commentable_type.demodulize}-#{model.id}-user-group-id"
        end

        def comment_as_options
          [[UserPresenter.new(current_user), ""]] + verified_group_users.map do |group|
            [UserGroupPresenter.new(group), group.id]
          end
        end

        def verified_group_users
          return [] unless current_user

          @verified_user_groups ||= Decidim::GroupUsers::ManageableGroupUsers.for(current_user).verified
        end
      end
    end
  end
end
