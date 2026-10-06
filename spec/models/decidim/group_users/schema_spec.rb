# frozen_string_literal: true

require "spec_helper"

# rubocop:disable RSpec/DescribeClass
describe "Database schema" do
  it "has the decidim_user_group_memberships table" do
    expect(ActiveRecord::Base.connection.table_exists?(:decidim_user_group_memberships)).to be(true)
  end

  it "has user_groups_enabled on organizations" do
    expect(ActiveRecord::Base.connection.column_exists?(:decidim_organizations, :user_groups_enabled)).to be(true)
  end

  it "has decidim_user_group_id on comments" do
    expect(ActiveRecord::Base.connection.column_exists?(:decidim_comments_comments, :decidim_user_group_id)).to be(true)
  end

  it "has decidim_user_group_id on coauthorships" do
    expect(ActiveRecord::Base.connection.column_exists?(:decidim_coauthorships, :decidim_user_group_id)).to be(true)
  end

  it "has decidim_user_group_id on likes" do
    expect(ActiveRecord::Base.connection.column_exists?(:decidim_likes, :decidim_user_group_id)).to be(true)
  end
end
# rubocop:enable RSpec/DescribeClass
