FactoryBot.define do
  factory :message do
    user
    chatroom
    message { nil }
  end
end
