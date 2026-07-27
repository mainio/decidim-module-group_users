# frozen_string_literal: true

require "decidim/core/test/factories"
require "decidim/proposals/test/factories"

FactoryBot.define do
  factory :user_group, class: "Decidim::GroupUsers::UserGroup" do
    organization { create(:organization) }
    sequence(:name) { |n| "Test Group #{n}" }
    sequence(:nickname) { |n| "test_group_#{n}" }
    sequence(:email) { |n| "group_#{n}@test.local" }
    encrypted_password { "x" }
    confirmed_at { Time.current }
    officialized_at { Time.current }

    trait :unverified do
      officialized_at { nil }
    end
  end

  factory :user_group_membership, class: "Decidim::GroupUsers::UserGroupMembership" do
    user
    user_group
    role { "member" }

    trait :creator do
      role { "creator" }
    end

    trait :admin do
      role { "admin" }
    end
  end
end
