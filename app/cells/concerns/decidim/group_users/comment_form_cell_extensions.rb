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

        # Explicitly render the GroupUsers template to avoid conflicts
        # with other modules overriding the same view.
        def group_users_comment_as
          render(
            view: :comment_as,
            prefixes: [
              Decidim::GroupUsers::Engine.root.join(
                "app/cells/decidim/comments/comment_form"
              ).to_s
            ]
          )
        end
      end
    end
  end
end
