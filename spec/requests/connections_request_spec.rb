# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConnectionsController, type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'renders the index template' do
      get connections_path
      expect(response).to render_template(:index)
    end
  end

  describe 'POST #create' do
    it 'creates a new connection' do
      expect do
        post connections_path, params: { connection: { connected_user_id: other_user.id, status: 'pending' } },
                               as: :turbo_stream
      end.to change(Connection, :count).by(1)

      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH #update' do
    let(:connection) { create(:connection, user:, status: 'pending', connected_user_id: other_user.id) }

    it 'updates the connection status' do
      patch connection_path(connection), params: { connection: { status: 'accepted' } }, as: :turbo_stream

      expect(response).to have_http_status(:success)
      expect(connection.reload.status).to eq('accepted')
    end

    it 'creates a chatroom and updates connected_user_ids when status is accepted' do
      other_connection = create(:connection, user: other_user, status: 'pending', connected_user_id: user.id)

      expect do
        patch connection_path(other_connection), params: { connection: { status: 'accepted' } }, as: :turbo_stream
      end.to change(Chatroom, :count).by(1)
                                     .and change { user.reload.connected_user_ids.count }.by(1)
                                                                                         .and change {
                                                                                                other_user.reload.connected_user_ids.count
                                                                                              }.by(1)
    end
  end
end
