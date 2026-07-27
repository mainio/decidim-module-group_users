# frozen_string_literal: true

module Decidim
  module GroupUsers
    module CreateCommentExtensions
      extend ActiveSupport::Concern

      included do
        private

        alias_method :original_create_comment, :create_comment

        def create_comment
          original_create_comment

          return unless form.user_group_id.present?

          @comment.update_column(:decidim_user_group_id, form.user_group_id)
        end
      end
    end
  end
end