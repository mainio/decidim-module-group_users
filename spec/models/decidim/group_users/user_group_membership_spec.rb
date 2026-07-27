# frozen_string_literal: true

require "spec_helper"

module Decidim
  module GroupUsers
    describe UserGroupMembership do
      let(:organization) { create(:organization) }
      let(:user) { create(:user, organization: organization) }
      let(:user_group) { create(:user_group, organization: organization) }

      describe "associations" do
        let(:membership) do
          create(:user_group_membership, user: user, user_group: user_group, role: "creator")
        end

        it "belongs to a user" do
          expect(membership.user).to eq(user)
        end

        it "belongs to a user_group" do
          expect(membership.user_group).to eq(user_group)
        end
      end

      describe "creation" do
        it "creates a valid membership" do
          membership = described_class.create!(
            decidim_user_id: user.id,
            decidim_user_group_id: user_group.id,
            role: "member"
          )

          expect(membership).to be_persisted
          expect(membership.role).to eq("member")
        end

        it "supports different roles" do
          %w[creator admin member requested].each do |role|
            membership = described_class.create!(
              decidim_user_id: user.id,
              decidim_user_group_id: user_group.id,
              role: role
            )
            expect(membership.role).to eq(role)
            membership.destroy!
          end
        end
      end

      describe "referential integrity" do
        let!(:membership) do
          create(:user_group_membership, user: user, user_group: user_group, role: "creator")
        end

        it "can access the user's name" do
          expect(membership.user.name).to eq(user.name)
        end

        it "can access the group's name" do
          expect(membership.user_group.name).to eq(user_group.name)
        end

        it "can navigate from user to group" do
          expect(user.user_groups).to include(user_group)
        end

        it "can navigate from group to user" do
          expect(user_group.users).to include(user)
        end
      end

      describe "multiple memberships" do
        let(:other_user) { create(:user, organization: organization) }

        let!(:membership_a) do
          create(:user_group_membership, user: user, user_group: user_group, role: "creator")
        end
        let!(:membership_b) do
          create(:user_group_membership, user: other_user, user_group: user_group, role: "member")
        end

        it "allows multiple users in one group" do
          expect(user_group.users).to contain_exactly(user, other_user)
        end

        it "tracks roles per membership" do
          expect(membership_a.role).to eq("creator")
          expect(membership_b.role).to eq("member")
        end
      end
    end
  end
end