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

          return if form.user_group_id.blank?

          @comment.update_column(:decidim_user_group_id, form.user_group_id) # rubocop:disable Rails/SkipsModelValidations
        end
      end
    end
  end
end
