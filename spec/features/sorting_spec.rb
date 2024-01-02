# spec/features/sorting_spec.rb

require 'rails_helper'

RSpec.feature 'Sorting', type: :feature do
  let(:user) { create(:user) }

  before :each do
    sign_in(user)
    visit root_path
  end

  it 'sorts posts by newest' do

    # lets create a first post
    find('#add-post-link', wait: 10).click
    expect(page).to have_text('Uploade your post', wait: 10)

    fill_in 'post_title', with: 'Sample Post'
    fill_in 'post_description', with: 'This is a sample post description.'
    click_button 'Save Changes'

    expect(page).to have_text('Sample Post')
    expect(page).to have_text('This is a sample post description.')

    # lets create a second post

    find('#add-post-link', wait: 10).click
    expect(page).to have_text('Uploade your post', wait: 10)

    fill_in 'post_title', with: 'Dummy Post'
    fill_in 'post_description', with: 'This is a dummy post description.'
    click_button 'Save Changes'

    expect(page).to have_text('Sample Post')
    expect(page).to have_text('This is a sample post description.')

    # lets create a third post

    find('#add-post-link', wait: 10).click
    expect(page).to have_text('Uploade your post', wait: 10)

    fill_in 'post_title', with: 'Ruby on Rails'
    fill_in 'post_description', with: 'This post is related to the Ruby on Rails.'
    click_button 'Save Changes'

    expect(page).to have_text('Ruby on Rails')
    expect(page).to have_text('This post is related to the Ruby on Rails.')

    find('#sort_by', wait: 10).select('Oldest')
    sleep 2  
    find('#sort_by', wait: 10).select('A-Z')
    sleep 2  
    find('#sort_by', wait: 10).select('Z-A')
    sleep 2
    find('#sort_by', wait: 10).select('Newest')
    sleep 2
  end

end
