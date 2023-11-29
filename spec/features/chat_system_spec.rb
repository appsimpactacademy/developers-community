# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Chat feature', js: true do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user) }
  let!(:connection1) { create(:connection, user: user1, connected_user_id: user2.id, status: 'accepted') }
  let!(:connection2) { create(:connection, user: user1, connected_user_id: user3.id, status: 'accepted') }

  describe 'Accepting a Connection Request' do
    it 'creates a chatroom when a connection request is accepted' do
      connection = create(:connection, user: user1, connected_user_id: user2.id, status: 'pending')

      sign_in(user2)

      visit connections_path

      # Assuming you have a variable `connection` with the connection you want to test
      connection_id = connection.id

      # Execute JavaScript with the dynamic connection ID
      page.execute_script("
        var connectionId = #{connection_id};
        var xhr = new XMLHttpRequest();
        xhr.open('PATCH', '/connections/' + connectionId, true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.send('connection[status]=accepted');
      ")

      # Check if a chatroom has been created
      expect(Chatroom.count).to eq(0)
      sleep 1
      expect(Chatroom.count).to eq(1)
      chatroom = Chatroom.between_users(user2, user1).first

      expect(chatroom).to be_present
      expect(chatroom.user1).to eq(user2)
      expect(chatroom.user2).to eq(user1)
    end
  end

  before do
    sign_in(user1)
  end

  describe 'Message Index Page' do
    let!(:chatroom) { create(:chatroom, user1:, user2:) }
    let!(:chatroom2) { create(:chatroom, user1:, user2: user3) }
    let!(:message) { create(:message, user: user1, chatroom:, message: 'Hi here is my code 2367') }
    let!(:message2) { create(:message, user: user1, chatroom:, message: 'my code 4567') }
    it 'displays a list of connected users and by default first user chatroom is open' do
      connected_user = user2
      visit messages_path

      expect(page).to have_content(connected_user.name)
      find('#chat-window-user')
      # expect(element).to have_content(user2.name)
      # expect(page).to have_selector('#chat-window-container')
    end

    it 'Opening a Chat allows the user to open a chat with another user' do
      create(:chatroom, user1:, user2: user3)

      visit messages_path
      find("h3[data-user-id='#{user3.id}']").click

      element = find('#chat-window-user', wait: 10)
      expect(element).to have_content(user3.name)

      expect(page).to have_selector('#chat-window-container')
    end

    it 'Sending chat a message to user' do
      visit messages_path

      find("h3[data-user-id='#{user3.id}']").click

      fill_in 'message_message', with: 'Hello !!!'

      click_button 'Send', class: 'btn btn-primary'

      sleep 5

      element = find('#user-message', wait: 20)

      expect(element).to have_content('Hello !!!')

      sign_in(user3)

      visit messages_path

      sleep 5

      element = find('#chat-window-user', wait: 10)
      expect(element).to have_content(user1.name)

      element = find('#user-message', wait: 20)

      expect(element).to have_content('Hello !!!')
    end

    it 'Search by username' do
      visit messages_path

      sleep 2

      fill_in 'search-input', with: user2.name.to_s

      sleep 5

      # First, make sure the "chat-lists" element is present
      expect(page).to have_css('.chat-lists')

      # Then, check the number of child elements it has
      expect(page).to have_css('.chat-lists > *', count: 1)
    end

    it 'Search by last message' do
      visit messages_path

      find("h3[data-user-id='#{user3.id}']").click

      sleep 3

      fill_in 'message_message', with: '2356 !!'

      click_button 'Send', class: 'btn btn-primary'

      sleep 5

      element = find('#user-message', wait: 10)

      expect(element).to have_content('2356 !!')

      sleep 2

      fill_in 'search-input', with: '2356 !!'

      sleep 5

      # First, make sure the "chat-lists" element is present
      expect(page).to have_css('.chat-lists')

      # Then, check the number of child elements it has
      expect(page).to have_css('.chat-lists > *', count: 1)

      element = find('.user-name', wait: 20)

      expect(element).to have_content(user3.name.to_s)
    end

    it 'Search by chatroom message' do
      visit messages_path

      fill_in 'search-input', with: 'my code 2367'

      sleep 5

      element = find('.user-name', wait: 20)

      expect(element).to have_content(user2.name.to_s)
    end
  end
end
