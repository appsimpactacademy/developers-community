require 'rails_helper'

RSpec.feature 'View Button for User Post', type: :feature do
  let(:current_user) { create(:user, username: 'current_user') }
  let(:other_user) { create(:user, username: 'other_user') }
  let(:other_user_post) { create(:post, user: other_user, title: 'Other User Post', description: 'This is a post by other_user.') }

  before :each do
    sign_in(other_user)
    visit root_path

    # create the post by other user
    find('#add-post-link', wait: 10).click
    expect(page).to have_text('Uploade your post', wait: 10)

    fill_in 'post_title', with: 'Other User Post'
    fill_in 'post_description', with: 'This is a post by other_user.'
    click_button 'Save Changes'

    expect(page).to have_text('Other User Post')
    expect(page).to have_text('This is a post by other_user.')

    # Log in as current_user
    sign_in(current_user)

    # Visit root path
    visit root_path

    # Display the post created by other_user with a wait time
    expect(page).to have_text('Other User Post', wait: 10)
    expect(page).to have_text('This is a post by other_user')

    # Click on the dropdown button
    find('#dropdownMenuLink').click

    # Click on the view button
    find("#view_post_button_#{other_user.id}").click
  end

  it 'go to post path when posts exist' do

    # find('#pills-home-tab', wait: 10).click

    visit post_path(other_user_post)

    expect(page).to have_text(other_user.name)
    expect(page).to have_text(other_user_post.title)
    expect(page).to have_text(other_user_post.description, wait: 10)

    find('#comment_container', wait: 10)
    sample_comment_content = 'This is a sample comment.'
    fill_in 'comment_content', with: sample_comment_content
    click_button 'Create Comment'
  end

  it 'should go to root path' do
    find('#back_to_home', wait: 10).click
    visit root_path
  end
end
