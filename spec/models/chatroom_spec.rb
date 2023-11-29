# frozen_string_literal: true

# spec/models/chatroom_spec.rb
# explanation
# Test the validity of a Chatroom object with and without two users.
# Test the association between Chatroom and Message, ensuring that a chatroom has many messages.
# Test the between_users scope to check if it correctly returns chatrooms between two specified users and doesn't return chatrooms with different users.

require 'rails_helper'

RSpec.describe Chatroom, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  it 'is valid with two users' do
    chatroom = Chatroom.new(user1:, user2:)
    expect(chatroom).to be_valid
  end

  it 'is not valid without two users' do
    chatroom = Chatroom.new(user1:)
    expect(chatroom).to_not be_valid
  end

  it 'has many messages' do
    chatroom = Chatroom.new(user1:, user2:)
    expect(chatroom.messages).to be_empty

    message1 = create(:message, message: 'Test message 1', chatroom:, user: user1)
    message2 = create(:message, message: 'Test message 2', chatroom:, user: user2)

    expect(chatroom.messages).to include(message1)
    expect(chatroom.messages).to include(message2)
  end

  describe 'between_users scope' do
    it 'returns the chatroom between two users' do
      chatroom1 = create(:chatroom, user1:, user2:)
      chatroom2 = create(:chatroom, user1: user2, user2: user1)

      result = Chatroom.between_users(user1, user2)

      expect(result).to include(chatroom1)
      expect(result).to include(chatroom2)
    end

    it 'does not return chatrooms with different users' do
      other_user = create(:user)
      chatroom = create(:chatroom, user1:, user2: other_user)

      result = Chatroom.between_users(user1, user2)

      expect(result).not_to include(chatroom)
    end
  end
end
