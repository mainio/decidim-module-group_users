# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/group_users/version"

Gem::Specification.new do |s|
  s.version = Decidim::GroupUsers.version
  s.authors = ["Sina Eftekhar"]
  s.email = ["sina.eftekhar@mainiotech.fi"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/mainio/decidim-module-group_users"
  s.required_ruby_version = "~> 3.3.0"

  s.name = "decidim-group_users"
  s.summary = "A decidim user group module"
  s.description = "Adds some legacy functionality related to the user groups."

  s.files = Dir["{app,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-admin", Decidim::GroupUsers.decidim_version
  s.add_dependency "decidim-core", Decidim::GroupUsers.decidim_version

  s.metadata["rubygems_mfa_required"] = "true"
end
