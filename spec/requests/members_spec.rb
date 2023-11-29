# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MembersController, type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe 'GET #show' do
    it 'renders the show template' do
      get member_path(user)
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #edit_description' do
    it 'renders the edit_description template' do
      get edit_member_description_path(user), as: :turbo_stream
      expect(response).to render_template(:edit_description)
    end
  end

  describe 'PATCH #update_description' do
    it 'updates the user description' do
      patch update_member_description_path, params: { user: { about: 'New description' } }, as: :turbo_stream
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit_personal_details' do
    it 'renders the edit_personal_details template' do
      get edit_member_personal_details_path(user)
      expect(response).to render_template(:edit_personal_details)
    end
  end

  describe 'PATCH #update_personal_details' do
    it 'updates the user personal details' do
      expect do
        patch update_member_personal_details_path, params: { user: { first_name: 'John' } }, as: :turbo_stream
      end.to change { user.reload.first_name }.to('John')

      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #connections' do
    it 'renders the connections template' do
      get member_connections_path(user), as: :turbo_stream
      expect(response).to render_template(:connections)
    end
  end

  # Add more specs for other actions like follow, unfollow, followers_and_following, etc.
end
