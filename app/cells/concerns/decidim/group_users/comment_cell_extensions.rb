# frozen_string_literal: true

module Decidim
  module GroupUsers
    module CommentCellExtensions
      extend ActiveSupport::Concern

      included do
        def author_presenter
          if model.decidim_user_group_id.present?
            group = Decidim::GroupUsers::UserGroup.find_by(id: model.decidim_user_group_id)
            return group.presenter if group
          end

          if model.author.respond_to?(:official?) && model.author.official?
            Decidim::Core::OfficialAuthorPresenter.new
          else
            model.author.presenter
          end
        end
      end
    end
  end
end