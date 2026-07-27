# frozen_string_literal: true

module Decidim
  module GroupUsers
    module CommentFormExtensions
      extend ActiveSupport::Concern

      included do
        attribute :user_group_id, Integer

        def user_group
          return unless user_group_id.present?

          Decidim::GroupUsers::UserGroup.find_by(id: user_group_id)
        end
      end
    end
  end
end