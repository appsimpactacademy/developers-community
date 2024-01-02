require 'rails_helper'

RSpec.feature 'Repost Post', type: :feature do
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

    find('#add_repost', wait: 10).click

    expect(page).to have_text('You cannot repost your own post.')
  end

  it 'should show an alert message when reposting the post of another user' do
    sign_in(current_user)

    visit root_path

    expect(page).to have_text('Other User Post', wait: 10)
    expect(page).to have_text('This is a post by other_user')

    # Repost the other user's post
    click_link 'Repost'

    # Assert that the alert message is displayed
    expect(page).to have_text('Reposted by You')

    expect(page).to have_text('Post reposted successfully.') 

    # Remove the repost
    click_link 'Remove Repost'

    expect(page).to_not have_text('Reposted by You')

    expect(page).to have_text('Repost removed')
  end
end
