# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

base_path = ""
base_path = "../" if File.basename(__dir__) == "development_app"
require_relative "#{base_path}lib/decidim/group_users/version"

DECIDIM_VERSION = Decidim::GroupUsers.decidim_version

gem "decidim", DECIDIM_VERSION

gem "decidim-group_users", path: "."

gem "bootsnap", "~> 1.4"

gem "puma", ">= 6.4.2"

gem "faker", "~> 3.2"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri
  gem "decidim-dev", DECIDIM_VERSION
  gem "decidim-initiatives", DECIDIM_VERSION

  # Fix issue with simplecov-cobertura
  # See: https://github.com/jessebs/simplecov-cobertura/pull/44
  gem "letter_opener_web", "~> 3.0"
  gem "rexml", "3.4.1"
end

group :development do
  gem "listen", "~> 3.1"
  gem "rubocop-faker"
  gem "web-console", "~> 4.2"
end

group :test do
  gem "codecov", require: false
end
