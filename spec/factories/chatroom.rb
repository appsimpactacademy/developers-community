# frozen_string_literal: true

FactoryBot.define do
  factory :chatroom do
    user1 { create(:user) } # You can use FactoryBot to create associated users
    user2 { create(:user) }
    # Add other chatroom attributes as needed
  end
end
