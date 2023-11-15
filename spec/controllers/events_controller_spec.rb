# spec/controllers/events_controller_spec.rb
require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:user) { create(:user) } # assuming you have a User model with a factory

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a successful response' do
      sign_in user
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new event' do
        sign_in user
        event_params = attributes_for(:event) # assuming you have a Event factory
        expect {
          post :create, params: { event: event_params }
        }.to change(Event, :count).by(1)
      end

      it 'redirects to the events path' do
        sign_in user
        post :create, params: { event: attributes_for(:event) }
        expect(response).to redirect_to(events_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new event' do
        sign_in user
        expect {
          post :create, params: { event: { event_type: 'invalid' } }
        }.not_to change(Event, :count)
      end

      it 'renders the new template' do
        sign_in user
        post :create, params: { event: { event_type: 'invalid' } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #show' do
    let(:event) { create(:event) }

    it 'returns a successful response' do
      get :show, params: { id: event.id }
      expect(response).to be_successful
    end
  end

  # Similar tests can be written for edit, update, destroy actions

  describe 'GET #calendar_events' do
    it 'returns a successful response' do
      get :calendar_events, format: :json
      expect(response).to be_successful
    end
  end
end
