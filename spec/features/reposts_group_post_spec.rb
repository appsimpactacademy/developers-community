require 'rails_helper'

RSpec.feature 'Repost Post', type: :feature do
  let(:current_user) { create(:user, username: 'current_user') }
  let(:other_user) { create(:user, username: 'other_user') }
  let(:other_user_post) { create(:post, user: other_user, title: 'Other User Post', description: 'This is a post by other_user.') }

  before :each do
    sign_in(other_user)
    visit root_path

    find('#groups', wait: 10).click

    visit groups_path

    click_link 'Create Group'

    expect(page).to have_text('Create Group')

    fill_in 'group_name', with: 'Tech Enthusiasts'
    fill_in 'group_description', with: 'A group for tech discussions.'
    select 'Software Development', from: 'group_industry'
    fill_in 'group_location', with: 'San Francisco'
    select 'Public', from: 'group_group_type'

    click_button 'Create Group'

    visit groups_path

    expect(page).to have_text('Tech Enthusiasts')

    click_link 'View'

    group_id = Group.last.id

    visit group_path(group_id)

    find('#group_post_link', wait: 10).click
    expect(page).to have_text('Uploade your post', wait: 10)

    fill_in 'post_title', with: 'Sample Post for group'
    fill_in 'post_description', with: 'This is a sample post description for group.'
    click_button 'Save Changes'

    group_id = Group.last.id

    visit group_path(group_id)

    expect(page).to have_text('Sample Post for group')
    expect(page).to have_text('This is a sample post description for group.')

    find('#add_group_reposts', wait: 10).click

    expect(page).to have_text('You cannot repost your own post.')

  end

  it 'should show an alert message when reposting the post of another user' do
    sign_in(current_user)

    visit root_path

    find('#groups', wait: 10).click

    visit groups_path

    expect(page).to have_text('Tech Enthusiasts')

    click_link 'View'

    group_id = Group.last.id

    visit group_path(group_id)

    expect(page).to have_text('Sample Post for group')
    expect(page).to have_text('This is a sample post description for group.')

    # Repost the other user's post
    click_link 'Repost'

    expect(page).to have_text('Post reposted successfully.') 

    # Remove the repost
    find('#groups', wait: 10).click

    visit groups_path

    expect(page).to have_text('Tech Enthusiasts')

    click_link 'View'

    group_id = Group.last.id

    visit group_path(group_id)

    expect(page).to have_text('Sample Post for group')
    expect(page).to have_text('This is a sample post description for group.')

    click_link 'Remove Repost'

    expect(page).to_not have_text('Reposted by You')

    expect(page).to have_text('Repost removed')
  end
end
