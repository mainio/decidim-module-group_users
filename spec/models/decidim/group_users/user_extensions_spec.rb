# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe User do
    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization: organization) }

    describe "associations" do
      it "has many group_memberships" do
        expect(user).to respond_to(:group_memberships)
        expect(user.group_memberships).to be_an(ActiveRecord::Associations::CollectionProxy)
      end

      it "has many user_groups through group_memberships" do
        expect(user).to respond_to(:user_groups)
        expect(user.user_groups).to be_an(ActiveRecord::Associations::CollectionProxy)
      end
    end

    describe "#user_groups" do
      let!(:group) { create(:user_group, organization: organization) }
      let!(:membership) do
        create(:user_group_membership, user:, user_group: group, role: "creator")
      end

      it "returns the user's groups" do
        expect(user.user_groups).to include(group)
      end

      it "returns empty when user has no groups" do
        other_user = create(:user, organization: organization)
        expect(other_user.user_groups).to be_empty
      end
    end

    describe "#group_memberships" do
      let!(:group) { create(:user_group, organization: organization) }
      let!(:membership) do
        create(:user_group_membership, user:, user_group: group, role: "admin")
      end

      it "returns the user's memberships" do
        expect(user.group_memberships).to include(membership)
      end

      it "returns membership with correct role" do
        expect(user.group_memberships.first.role).to eq("admin")
      end

      it "destroys memberships when user is destroyed" do
        expect { user.destroy }.to change(
          Decidim::GroupUsers::UserGroupMembership, :count
        ).by(-1)
      end
    end

    describe "multiple groups" do
      let!(:group_a) { create(:user_group, organization: organization, name: "Group A") }
      let!(:group_b) { create(:user_group, organization: organization, name: "Group B") }
      let!(:membership_a) do
        create(:user_group_membership, user: user, user_group: group_a, role: "creator")
      end
      let!(:membership_b) do
        create(:user_group_membership, user: user, user_group: group_b, role: "member")
      end

      it "returns all groups the user belongs to" do
        expect(user.user_groups).to contain_exactly(group_a, group_b)
      end
    end

    describe "cross-organization isolation" do
      let(:other_organization) { create(:organization) }
      let!(:group) { create(:user_group, organization: organization) }
      let!(:other_group) { create(:user_group, organization: other_organization) }
      let!(:membership) do
        create(:user_group_membership, user: user, user_group: group, role: "creator")
      end

      it "only returns groups from the user's memberships" do
        expect(user.user_groups).to include(group)
        expect(user.user_groups).not_to include(other_group)
      end
    end
  end
end
