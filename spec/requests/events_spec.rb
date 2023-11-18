# spec/requests/events_spec.rb
require 'rails_helper'

RSpec.describe 'Events', type: :request do
  let(:user) { create(:user) } # assuming you have a User model with a factory
  
  before do
  	sign_in user
  end

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
      it 'creates a new event' do
 
        event_params = attributes_for(:event) # assuming you have an Event factory
        expect {
          post events_path, params: { event: event_params }
        }.to change(Event, :count).by(1)
      end

      it 'redirects to the events path' do
 
        post events_path, params: { event: attributes_for(:event) }
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
      sign_in user
      get edit_event_path(event), as: :turbo_stream
      expect(response).to be_successful
    end
  end

  describe 'PATCH /events/:id' do
    let(:event) { create(:event) }

    context 'with valid parameters' do
      it 'updates the event' do
        sign_in user
        patch event_path(event), params: { event: { event_name: 'Updated Title' } }, as: :turbo_stream
        expect(event.reload.event_name).to eq('Updated Title')
      end
    end

    # Add more tests for handling invalid parameters if needed
  end

  describe 'DELETE /events/:id' do
    let(:event) { create(:event) }

    it 'destroys the event' do
      sign_in user
      expect {
        delete event_path(event), as: :turbo_stream
      }.to change(Event, :count).by(0)
    end

    it 'redirects to the events path' do
      sign_in user
      delete event_path(event), as: :turbo_stream
      expect(response).to redirect_to(events_path)
    end
  end

  describe 'GET /calendar_events' do
    it 'returns a successful response' do
      sign_in user 	
      get calendar_events_events_path(format: :json)
      expect(response).to be_successful
    end
  end
end
