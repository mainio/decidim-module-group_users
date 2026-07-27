# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Comments
    describe CommentForm do
      let(:organization) { create(:organization) }
      let(:user) { create(:user, organization: organization) }
      let(:user_group) { create(:user_group, organization: organization) }

      describe "user_group_id attribute" do
        it "accepts a user_group_id" do
          form = CommentForm.from_params(
            body: "test",
            alignment: 0,
            user_group_id: user_group.id
          )

          expect(form.user_group_id).to eq(user_group.id)
        end

        it "accepts blank user_group_id" do
          form = CommentForm.from_params(
            body: "test",
            alignment: 0,
            user_group_id: ""
          )

          expect(form.user_group_id).to be_nil
        end
      end

      describe "#user_group" do
        it "returns the user group when id is present" do
          form = CommentForm.from_params(
            body: "test",
            alignment: 0,
            user_group_id: user_group.id
          )

          expect(form.user_group).to eq(user_group)
        end

        it "returns nil when id is blank" do
          form = CommentForm.from_params(
            body: "test",
            alignment: 0,
            user_group_id: ""
          )

          expect(form.user_group).to be_nil
        end

        it "returns nil when group doesn't exist" do
          form = CommentForm.from_params(
            body: "test",
            alignment: 0,
            user_group_id: 999_999
          )

          expect(form.user_group).to be_nil
        end
      end
    end
  end
end
