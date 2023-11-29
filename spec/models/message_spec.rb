# frozen_string_literal: true

# spec/models/message_spec.rb

require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:user) { create(:user) }
  let(:chatroom) { create(:chatroom) }

  it 'belongs to a user' do
    message = create(:message, user:, chatroom:, message: 'Test message')
    expect(message.user).to eq(user)
  end

  it 'belongs to a chatroom' do
    message = create(:message, user:, chatroom:, message: 'Test message')
    expect(message.chatroom).to eq(chatroom)
  end

  it 'validates presence of message' do
    message = build(:message, user:, chatroom:, message: nil)
    expect(message).not_to be_valid
  end

  it 'checks if the message was sent by a specific user' do
    other_user = create(:user)
    message = create(:message, user:, chatroom:, message: 'Test message')
    expect(message.sent_by?(user)).to be true
    expect(message.sent_by?(other_user)).to be false
  end
end
