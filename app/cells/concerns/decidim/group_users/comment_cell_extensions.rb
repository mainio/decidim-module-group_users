# frozen_string_literal: true

module Decidim
  module GroupUsers
    module CommentCellExtensions
      extend ActiveSupport::Concern

      included do
        def author_presenter
          if model.author.respond_to?(:official?) && model.author.official?
            Decidim::Core::OfficialAuthorPresenter.new
          elsif model.user_group
            model.user_group.presenter
          else
            model.author.presenter
          end
        end
      end
    end
  end
end
