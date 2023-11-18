# spec/requests/connections_spec.rb

require 'rails_helper'

RSpec.describe ConnectionsController, type: :request do
  let(:user) { create(:user) } # Assuming you have a User model and a user factory

  describe 'GET #index' do
    it 'renders the index template' do
      sign_in user
      get connections_path
      expect(response).to render_template(:index)
    end
  end

  describe 'POST #create' do
    let(:other_user) { create(:user) }

    it 'creates a new connection' do
      sign_in user

      expect {
        post connections_path, params: { connection: { connected_user_id: other_user.id, status: 'pending' } }, as: :turbo_stream
      }.to change(Connection, :count).by(1)

      expect(response).to have_http_status(:success) # Assuming you want a success response
    end
  end

  describe 'PATCH #update' do
    let(:other_user) { create(:user) }
    let(:connection) { create(:connection, user: user, status: 'pending', connected_user_id: other_user.id) }
 
    it 'updates the connection status' do
      sign_in user

      patch connection_path(connection), params: { connection: { status: 'accepted' } }, as: :turbo_stream

      expect(response).to have_http_status(:success)
      expect(connection.reload.status).to eq('accepted')
    end

    it 'creates a chatroom and updates connected_user_ids when status is accepted' do
      sign_in user
      other_user = create(:user)
      other_connection = create(:connection, user: other_user, status: 'pending', connected_user_id: user.id)

      expect {
        patch connection_path(other_connection), params: { connection: { status: 'accepted' } }, as: :turbo_stream
      }.to change(Chatroom, :count).by(1)
       .and change { user.reload.connected_user_ids.count }.by(1)
       .and change { other_user.reload.connected_user_ids.count }.by(1)
    end
  end
end
