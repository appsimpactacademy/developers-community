require 'rails_helper'

RSpec.feature 'Notifications', type: :feature do
  let(:current_user) { create(:user, username: 'current_user') }
  let(:other_user) { create(:user, username: 'other_user') }
  let(:other_user_post) { create(:post, user: other_user, title: 'Other User Post', description: 'This is a post by other_user.') }
  let(:connection) { create(:connection, user: current_user, connected_user: other_user, status: 'pending') }

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

    find('#user_profile').click
  end

  it 'should visit the user path & click on connection button for sending the request to the other user' do
    
    sign_in(current_user)

    visit root_path
    expect(page).to have_text('Other User Post', wait: 10)
    expect(page).to have_text('This is a post by other_user')

    find('#user_profile').click

    expect(page).to have_css('#connection_button', wait: 10)
    
    within('#user-connection-status') do
      find('#connection_button', wait: 10).click
    end

    expect(page).to have_button('Pending')
    expect(page).to have_text("Your connection request has been send, but it is in pending state. You will get connected once #{other_user.name} will accept your connection request.")

    sign_in(other_user)
    visit root_path

    find('#add-my-network-link', wait: 10).click
  end

  it 'should reject the connection request' do
    sign_in(current_user)

    visit root_path
    expect(page).to have_text('Other User Post', wait: 10)
    expect(page).to have_text('This is a post by other_user')

    find('#user_profile').click

    expect(page).to have_css('#connection_button', wait: 10)
    
    within('#user-connection-status') do
      find('#connection_button', wait: 10).click
    end

    expect(page).to have_button('Pending')
    expect(page).to have_text("Your connection request has been send, but it is in pending state. You will get connected once #{other_user.name} will accept your connection request.")

    sign_in(other_user)
    visit root_path

    find('#add-my-network-link', wait: 10).click

    expect(page).to have_text("#{current_user.name}")
    
    find('#reject_button', wait: 10).click
  end

  it 'should accept the connection request' do
    sign_in(current_user)

    visit root_path
    expect(page).to have_text('Other User Post', wait: 10)
    expect(page).to have_text('This is a post by other_user')

    find('#user_profile').click

    expect(page).to have_css('#connection_button', wait: 10)
    
    within('#user-connection-status') do
      find('#connection_button', wait: 10).click
    end

    expect(page).to have_button('Pending')
    expect(page).to have_text("Your connection request has been send, but it is in pending state. You will get connected once #{other_user.name} will accept your connection request.")

    sign_in(other_user)
    visit root_path

    find('#add-my-network-link', wait: 10).click

    expect(page).to have_text("#{current_user.name}")
    
    find('#accept_button', wait: 10).click
  end

  it 'should check the notification is present or not' do
    sign_in(other_user)

    find('#notification_bell', wait: 10).click

    expect(page).to have_text('No notification is present!')
  end

  it 'should like on post to get the notification & delete the notification' do
    sign_in(current_user)

    visit root_path
    expect(page).to have_text('Other User Post', wait: 10)
    expect(page).to have_text('This is a post by other_user')

    find('#user_profile', wait: 10, wait: 10).click

    expect(page).to have_css('#connection_button', wait: 10)
    
    within('#user-connection-status') do
      find('#connection_button', wait: 10).click
    end

    expect(page).to have_button('Pending')
    expect(page).to have_text("Your connection request has been send, but it is in pending state. You will get connected once #{other_user.name} will accept your connection request.")

    sign_in(other_user)
    visit root_path

    find('#add-my-network-link', wait: 10).click

    expect(page).to have_text("#{current_user.name}")
    
    find('#accept_button', wait: 10).click

    sign_in(current_user) 

    visit root_path
    expect(page).to have_text('Other User Post', wait: 10)
    expect(page).to have_text('This is a post by other_user')

    find('#like_button', wait: 10).click

    sleep 2

    sign_in(other_user)
    visit root_path

    find('#notification_bell', wait: 10).click

    expect(page).to have_text('Notifications')
    expect(page).to have_text("#{current_user.name} just liked : Other User Post")

    find('#like_delete_button', wait: 10).click    

    alert = page.driver.browser.switch_to.alert

    # Verify the alert text
    expect(alert.text).to eq('Are you sure you want to mark this notification as read?')

    # Accept or dismiss the alert
    alert.accept

    expect(page).to have_text('No notification is present!', wait: 10)
  end

  it 'should current user visit on other users post & then comment on other user post then get the notification & delete the notification' do
    sign_in(current_user)

    visit root_path
    expect(page).to have_text('Other User Post', wait: 10)
    expect(page).to have_text('This is a post by other_user')

    find('#user_profile', wait: 10).click

    expect(page).to have_css('#connection_button', wait: 10)
    
    within('#user-connection-status') do
      find('#connection_button', wait: 10).click
    end

    expect(page).to have_button('Pending')
    expect(page).to have_text("Your connection request has been send, but it is in pending state. You will get connected once #{other_user.name} will accept your connection request.")

    sign_in(other_user)
    visit root_path

    find('#add-my-network-link', wait: 10).click

    expect(page).to have_text("#{current_user.name}")
    
    find('#accept_button', wait: 10).click

    sign_in(current_user) 

    visit root_path
    expect(page).to have_text('Other User Post', wait: 10)
    expect(page).to have_text('This is a post by other_user')

    click_link 'Other User Post'

    # find('#direct_link_for_user_post', wait: 10).click

    find('#comment_container', wait: 10)
    sample_comment_content = 'This is a sample comment.'
    fill_in 'comment_content', with: sample_comment_content
    click_button 'Create Comment'

    sleep 2

    sign_in(other_user)
    visit root_path

    find('#notification_bell', wait: 10).click

    expect(page).to have_text('Notifications')
    expect(page).to have_text("#{current_user.name} just commented on : Other User Post")

    find('#comment_delete_button', wait: 10).click

    alert = page.driver.browser.switch_to.alert

    # Verify the alert text
    expect(alert.text).to eq('Are you sure you want to mark this notification as read?')

    # Accept or dismiss the alert
    alert.accept

    expect(page).to have_text('No notification is present!', wait: 10)
  end
end
