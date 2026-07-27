# frozen_string_literal: true

require "spec_helper"

describe "Comment as user group" do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :confirmed, organization: organization) }
  let(:participatory_process) { create(:participatory_process, :with_steps, organization: organization) }
  let(:component) { create(:proposal_component, participatory_space: participatory_process) }
  let(:proposal) { create(:proposal, component: component) }

  let!(:user_group) { create(:user_group, organization: organization, name: "My Test Group") }
  let!(:membership) do
    create(:user_group_membership, user: user, user_group: user_group, role: "creator")
  end

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
  end

  context "when user belongs to a verified group" do
    it "shows the comment-as dropdown" do
      visit_proposal

      within ".add-comment" do
        expect(page).to have_css(".comment__as")
        expect(page).to have_content("Your profile")
      end
    end

    it "shows the user's name as default selection" do
      visit_proposal

      within ".comment__as" do
        expect(page).to have_content(user.name)
      end
    end

    it "shows the user group as an option" do
      visit_proposal

      within ".comment__as" do
        # Click to open dropdown
        find("button").click
        expect(page).to have_content("My Test Group")
      end
    end

    it "allows selecting the user group" do
      visit_proposal

      within ".comment__as" do
        find("button").click
        find("li", text: "My Test Group").click
      end

      radio = find("input[value='#{user_group.id}']", visible: :all)
      expect(radio).to be_checked
    end

    it "submits a comment as the user group", :slow do
      visit_proposal

      within ".add-comment" do
        # Select the user group
        within ".comment__as" do
          find("button").click
          find("li", text: "My Test Group").click
        end

        # Write and submit the comment
        fill_in "comment[body]", with: "This is a group comment"
        click_on "Publish comment"
      end

      # Verify the comment was published
      expect(page).to have_content("This is a group comment")
    end

    it "submits a comment as the user (default)" do
      visit_proposal

      within ".add-comment" do
        fill_in "comment[body]", with: "This is a personal comment"
        click_on "Publish comment"
      end

      expect(page).to have_content("This is a personal comment")
    end

    it "creates a comment attributed to the user group" do
      visit_proposal

      within ".add-comment" do
        within ".comment__as" do
          find("button").click
          find("li", text: "My Test Group").click
        end

        fill_in "comment[body]", with: "This is a group comment"
        click_on "Publish comment"
      end

      expect(page).to have_content("This is a group comment")

      # Verify the comment is attributed to the group
      comment = Decidim::Comments::Comment.last
      expect(comment.body["en"]).to eq("This is a group comment")

      expect(comment.decidim_user_group_id).to eq(user_group.id)
    end
  end

  context "when user belongs to an unverified group" do
    let!(:user_group) { create(:user_group, :unverified, organization: organization, name: "Unverified Group") }

    it "does not show the unverified group in the dropdown" do
      visit_proposal

      within ".add-comment" do
        expect(page).not_to have_css(".comment__as button")
        expect(page).not_to have_content("Unverified Group")
      end
    end
  end

  context "when user has no groups" do
    let!(:membership) { nil }
    let!(:user_group) { nil }

    it "does not show the comment-as dropdown" do
      visit_proposal

      within ".add-comment" do
        expect(page).not_to have_css(".comment__as button")
      end
    end
  end

  context "when user belongs to multiple groups" do
    let!(:second_group) { create(:user_group, organization: organization, name: "Second Group") }
    let!(:second_membership) do
      create(:user_group_membership, user: user, user_group: second_group, role: "admin")
    end

    it "shows all groups in the dropdown" do
      visit_proposal

      within ".comment__as" do
        find("button").click
        expect(page).to have_content("My Test Group")
        expect(page).to have_content("Second Group")
      end
    end

    it "allows switching between groups" do
      visit_proposal

      within ".comment__as" do
        find("button").click
        find("li", text: "My Test Group").click

        expect(find("input[value='#{user_group.id}']", visible: :all)).to be_checked

        find("button").click
        find("li", text: "Second Group").click

        expect(find("input[value='#{second_group.id}']", visible: :all)).to be_checked
      end
    end
  end

  private

  def visit_proposal
    page.visit "/processes/#{participatory_process.slug}/f/#{component.id}/proposals/#{proposal.id}"
    expect(page).to have_css(".add-comment", wait: 10)
  end
end