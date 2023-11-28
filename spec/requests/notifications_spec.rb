require 'rails_helper'

RSpec.describe 'Notifications', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:post) { create(:post, user: user) }

  before { sign_in user }

  describe 'GET /notifications' do
    it 'returns a successful response' do
      get notifications_path
      expect(response).to be_successful
    end

    it 'marks notifications as viewed' do
      notification = create(:notification, user: user, item_type: 'Post', item_id: post.id)
      get notifications_path
      expect(notification.reload.viewed).to eq(true)
    end
  end

  describe 'DELETE /notifications/:id' do
    let(:notification) { create(:notification, user: user, item_type: 'Post', item_id: post.id) }

    it 'destroys the notification' do
      expect {
        delete notification_path(notification)
      }.to change(Notification, :count).by(0)

      expect(response).to redirect_to(notifications_path)
      expect(flash[:alert]).to eq('Notification was successfully destroyed.')
    end
  end
end
