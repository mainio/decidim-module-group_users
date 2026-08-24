# frozen_string_literal: true

require "spec_helper"

describe "Decidim::GroupUsers.neutralize_user_group_migrations!" do
  let(:migrations_dir) { Rails.root.join("db", "migrate") }

  it "has neutralized RemoveUserGroupCore" do
    file = Dir.glob(migrations_dir.join("*_remove_user_group_core{,.*}.rb")).first
    expect(file).to be_present
    content = File.read(file)
    expect(content).not_to include("def up")
  end

  it "has neutralized RemoveUserGroupMemberships" do
    file = Dir.glob(migrations_dir.join("*_remove_user_group_memberships{,.*}.rb")).first
    expect(file).to be_present
    content = File.read(file)
    expect(content).not_to include("def up")
  end

  it "has neutralized RemoveUserGroupOrganizations" do
    file = Dir.glob(migrations_dir.join("*_remove_user_group_organizations{,.*}.rb")).first
    expect(file).to be_present
    content = File.read(file)
    expect(content).not_to include("def up")
  end

  it "has neutralized RemoveUserGroupComments" do
    file = Dir.glob(migrations_dir.join("*_remove_user_group_comments{,.*}.rb")).first
    expect(file).to be_present
    content = File.read(file)
    expect(content).not_to include("def up")
  end
end