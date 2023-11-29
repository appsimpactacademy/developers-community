# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Events', type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe 'GET /events' do
    it 'returns a successful response' do
      get events_path
      expect(response).to be_successful
    end
  end

  describe 'GET /events/new' do
    it 'returns a successful response' do
      get new_event_path, as: :turbo_stream
      expect(response).to be_successful
    end
  end

  describe 'POST /events' do
    context 'with valid parameters' do
      let(:event_params) { attributes_for(:event) }

      it 'creates a new event' do
        expect do
          post events_path, params: { event: event_params }
        end.to change(Event, :count).by(1)
      end

      it 'redirects to the events path' do
        post events_path, params: { event: event_params }
        expect(response).to redirect_to(events_path)
      end
    end
  end

  describe 'GET /events/:id' do
    let(:event) { create(:event) }

    it 'returns a successful response' do
      get event_path(event)
      expect(response).to be_successful
    end
  end

  describe 'GET /events/:id/edit' do
    let(:event) { create(:event) }

    it 'returns a successful response' do
      get edit_event_path(event), as: :turbo_stream
      expect(response).to be_successful
    end
  end

  describe 'PATCH /events/:id' do
    let(:event) { create(:event) }

    context 'with valid parameters' do
      it 'updates the event' do
        patch event_path(event), params: { event: { event_name: 'Updated Title' } }, as: :turbo_stream
        expect(event.reload.event_name).to eq('Updated Title')
      end
    end

    # Add more tests for handling invalid parameters if needed
  end

  describe 'DELETE /events/:id' do
    let(:event) { create(:event) }

    it 'destroys the event' do
      expect do
        delete event_path(event), as: :turbo_stream
      end.to change(Event, :count).by(0)
    end

    it 'redirects to the events path' do
      delete event_path(event), as: :turbo_stream
      expect(response).to redirect_to(events_path)
    end
  end

  describe 'GET /calendar_events' do
    it 'returns a successful response' do
      get calendar_events_events_path(format: :json)
      expect(response).to be_successful
    end
  end
end
