module Decidim
  module GroupUsers
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::GroupUsers

      initializer "decidim_group_users.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      initializer "decidim_group_users.add_cells_view_paths", before: "decidim_core.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::GroupUsers::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::GroupUsers::Engine.root}/app/views")
      end

      initializer "decidim_group_users.add_customizations", before: "decidim_comments.query_extensions" do
        config.to_prepare do
          # cells
          Decidim::Comments::CommentFormCell.include(
            Decidim::GroupUsers::CommentFormCellExtensions
          )
          Decidim::Comments::CommentCell.include(
            Decidim::GroupUsers::CommentCellExtensions
          )
          # models
          Decidim::User.include(
            Decidim::GroupUsers::UserExtensions
          )
          # forms
          Decidim::Comments::CommentForm.include(
            Decidim::GroupUsers::CommentFormExtensions
          )
          # commands
          Decidim::Comments::CreateComment.include(
            Decidim::GroupUsers::CreateCommentExtensions
          )
        end
      end
    end
  end
end