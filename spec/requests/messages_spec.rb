# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessagesController, type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:chatroom) { create(:chatroom, user1: user, user2: other_user) }

  before { sign_in user }

  describe 'GET /messages' do
    it 'returns a successful response with recent messages and chatrooms' do
      get messages_path

      expect(response).to be_successful
      expect(assigns(:received_connections)).not_to be_nil
      expect(assigns(:requested_connections)).not_to be_nil

      if assigns(:chatroom)
        expect(assigns(:messages)).not_to be_nil
        expect(assigns(:user)).not_to be_nil
      else
        expect(assigns(:messages)).to be_empty
        expect(assigns(:user)).to be_nil
      end
    end
  end

  describe 'GET /all_messages' do
    it 'returns all messages in JSON format' do
      create(:message, user:, chatroom:, message: 'Hello, World!')
      get all_messages_path, as: :json

      expect(response).to be_successful
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.length).to eq(1)
      expect(parsed_response.first['message']).to eq('Hello, World!')
    end
  end
end
