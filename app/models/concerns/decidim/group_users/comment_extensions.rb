# frozen_string_literal: true

module Decidim
  module GroupUsers
    module CommentExtensions
      extend ActiveSupport::Concern

      included do
        belongs_to :user_group,
                   class_name: "Decidim::GroupUsers::UserGroup",
                   foreign_key: :decidim_user_group_id,
                   optional: true
      end
    end
  end
end
