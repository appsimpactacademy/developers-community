# frozen_string_literal: true

FactoryBot.define do
  factory :page do
    title { 'Sample Page Title' }
    content { 'Sample Page Content' }
    industry { 'Sample Industry' }
    website { 'http://example.com' }
    organization_size { 'Sample Organization Size' }
    organization_type { 'Sample Organization Type' }
    about { 'About this page...' }

    # Assuming you have a User model and want to associate it with a user
    user

    created_at { Time.now }
    updated_at { Time.now }
  end
end
