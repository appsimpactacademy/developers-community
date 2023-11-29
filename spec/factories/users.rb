# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    username { "#{Faker::Name.first_name.downcase}_#{rand(1..1000)}" }
    email { Faker::Internet.email }
    contact_number { Faker::PhoneNumber.phone_number_with_country_code }
    street_address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    country { Faker::Address.country }
    pincode { Faker::Address.postcode }
    date_of_birth { (Date.today + rand(1..30).days) - rand(24..36).years }
    profile_title { User::PROFILE_TITLE.sample }
    password { 'password' }
    about do
      "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)."
    end
    confirmed_at { DateTime.now }
    connected_user_ids { [] }
  end
end
