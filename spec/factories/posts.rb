FactoryBot.define do
  factory :post do
    title { "MyString" }
    description { "MyText" }
    user { nil }
    hidden { false }
  end
end
