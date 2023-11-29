# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    user
    chatroom
    message { nil }
  end
end
