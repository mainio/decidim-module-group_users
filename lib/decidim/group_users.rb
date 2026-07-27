# frozen_string_literal: true

require "decidim/group_users/engine"

module Decidim
  module GroupUsers
    include ActiveSupport::Configurable

    autoload :Engine, "decidim/group_users/engine"
  end
end
