FactoryBot.define do
  factory :comment do
    commentable { nil }
    title { "MyString" }
  end
end
