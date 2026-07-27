# frozen_string_literal: true

require "spec_helper"

module Decidim
  module GroupUsers
    describe UserGroup do
      let(:organization) { create(:organization) }

      describe ".verified" do
        let!(:verified_group) { create(:user_group, organization: organization, officialized_at: Time.current) }
        let!(:unverified_group) { create(:user_group, :unverified, organization: organization) }

        it "returns only verified groups" do
          expect(described_class.verified).to include(verified_group)
          expect(described_class.verified).not_to include(unverified_group)
        end
      end

      describe "#deleted?" do
        let(:group) { create(:user_group, organization: organization) }

        it "returns false when deleted_at is nil" do
          expect(group.deleted?).to be(false)
        end

        it "returns true when deleted_at is set" do
          group.update_columns(deleted_at: Time.current) # rubocop:disable Rails/SkipsModelValidations
          expect(group.deleted?).to be(true)
        end
      end

      describe "associations" do
        let(:group) { create(:user_group, organization: organization) }
        let(:user) { create(:user, organization: organization) }
        let!(:membership) do
          create(:user_group_membership, user: user, user_group: group, role: "creator")
        end

        it "has many memberships" do
          expect(group.memberships).to include(membership)
        end

        it "has many users through memberships" do
          expect(group.users).to include(user)
        end
      end
    end
  end
end
