# frozen_string_literal: true

require "spec_helper"

describe Decidim::Comments::Comment do
  let(:organization) { create(:organization) }
  let(:user_group) do
    create(:user_group, organization:, name: "My Test Group")
  end

  describe "user_group association" do
    it "belongs to a user group" do
      association = described_class.reflect_on_association(:user_group)

      expect(association).not_to be_nil
      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq("Decidim::GroupUsers::UserGroup")
      expect(association.foreign_key).to eq("decidim_user_group_id")
    end

    it "resolves the associated user group" do
      comment = described_class.new(user_group:)

      expect(comment.user_group).to eq(user_group)
      expect(comment.decidim_user_group_id).to eq(user_group.id)
    end

    it "allows comments without a user group" do
      association = described_class.reflect_on_association(:user_group)

      expect(association.options[:optional]).to be(true)
    end
  end
end