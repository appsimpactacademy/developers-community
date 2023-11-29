# frozen_string_literal: true

# spec/models/page_spec.rb

require 'rails_helper'

RSpec.describe Page, type: :model do
  let(:user) { create(:user) }

  it 'has many posts' do
    page = create(:page, user:)
    post_1 = create(:post, user:, page:)
    post_2 = create(:post, user:, page:)

    expect(page.posts).to include(post_1, post_2)
  end

  it 'has many follows' do
    page = create(:page, user:)
    follower = create(:user)
    follow = create(:follow, followed: page, user: follower)

    expect(page.follows).to include(follow)
  end

  it 'has many followers through follows' do
    page = create(:page, user:)
    follower = create(:user)
    create(:follow, followed: page, user: follower)

    expect(page.followers).to include(follower)
  end

  it 'has a followers_count method that returns the count of followers' do
    page = create(:page, user:)
    follower_1 = create(:user)
    follower_2 = create(:user)
    create(:follow, followed: page, user: follower_1)
    create(:follow, followed: page, user: follower_2)

    expect(page.followers_count).to eq(2)
  end

  it 'validates ORGANIZATION_TYPE values' do
    page = create(:page, organization_type: 'Public company')
    expect(Page::ORGANIZATION_TYPE).to include(page.organization_type)
  end

  it 'validates ORGANIZATION_SIZE values' do
    page = create(:page, organization_size: '11-50 employees')
    expect(Page::ORGANIZATION_SIZE).to include(page.organization_size)
  end

  it 'validates INDUSTRY values' do
    page = create(:page, industry: 'IT System Testing and Evaluation')
    expect(Page::INDUSTRY).to include(page.industry)
  end
end
