# frozen_string_literal: true

require "spec_helper"

module Decidim
  module GroupUsers
    describe UserGroup do
      let(:organization) { create(:organization) }

      describe ".verified" do
        let!(:verified_group) do
          create(
            :user_group,
            organization:,
            extended_data: { "verified_at" => Time.current.iso8601 }
          )
        end

        let!(:unverified_group) do
          create(
            :user_group,
            organization:,
            extended_data: { "verified_at" => nil }
          )
        end

        it "returns groups with verified_at in extended_data" do
          expect(described_class.verified).to include(verified_group)
          expect(described_class.verified).not_to include(unverified_group)
        end

        it "does not use officialized_at to determine verification" do
          group = create(
            :user_group,
            organization:,
            officialized_at: Time.current,
            extended_data: { "verified_at" => nil }
          )

          expect(described_class.verified).not_to include(group)
        end
      end

      describe "#verified?" do
        it "returns true when verified_at is present in extended_data" do
          group = create(
            :user_group,
            organization:,
            extended_data: { "verified_at" => Time.current.iso8601 }
          )

          expect(group.verified?).to be(true)
        end

        it "returns false when verified_at is not present in extended_data" do
          group = create(
            :user_group,
            organization:,
            extended_data: { "verified_at" => nil }
          )

          expect(group.verified?).to be(false)
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

      describe "#confirmed?" do
        it "returns true when confirmed_at is set" do
          group = create(:user_group, organization:, confirmed_at: Time.current)

          expect(group.confirmed?).to be(true)
        end

        it "returns false when confirmed_at is nil" do
          group = create(:user_group, organization:, confirmed_at: nil)

          expect(group.confirmed?).to be(false)
        end
      end

      describe "#presenter" do
        let(:group) { create(:user_group, organization:) }

        it "returns a user group presenter" do
          expect(group.presenter).to be_a(Decidim::UserGroupPresenter)
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
