# spec/requests/work_experiences_controller_spec.rb

require 'rails_helper'

RSpec.describe WorkExperiencesController, type: :request do
  let(:user) { create(:user) }
  let(:work_experience) { create(:work_experience, user: user) }

  describe 'GET /work_experiences/new' do
    it 'returns a successful response' do
      sign_in user
      get new_work_experience_path, as: :turbo_stream
      expect(response).to be_successful
      expect(assigns(:work_experience)).to be_a_new(WorkExperience)
    end
  end

  describe 'GET /work_experiences/:id/edit' do
    it 'returns a successful response' do
      sign_in user
      get edit_work_experience_path(work_experience), as: :turbo_stream
      expect(response).to be_successful
      expect(assigns(:work_experience)).to eq(work_experience)
    end
  end

  describe 'POST /work_experiences' do
    context 'with valid parameters' do
      it 'creates a new work experience' do
        sign_in user
        work_experience_params = attributes_for(:work_experience, user_id: user.id)
        expect {
          post work_experiences_path, params: { work_experience: work_experience_params }, as: :turbo_stream
        }.to change(WorkExperience, :count).by(1)
      end

      it 'renders turbo_stream for successful creation' do
        sign_in user
        work_experience_params = attributes_for(:work_experience, user_id: user.id)
        post work_experiences_path, params: { work_experience: work_experience_params }, as: :turbo_stream

        expect(response).to be_successful
        expect(response.body).to include('turbo-stream')
      end
    end

    context 'with invalid parameters' do
      it 'renders turbo_stream for failed creation' do
        sign_in user
        post work_experiences_path, params: { work_experience: { invalid_param: 'invalid_value' } }, as: :turbo_stream

        expect(response).to be_successful
        expect(response.body).to include('turbo-stream')
      end
    end
  end

  describe 'PATCH /work_experiences/:id' do
    context 'with valid parameters' do
      it 'updates the work experience' do
        sign_in user
        new_location = 'New Location'
        patch work_experience_path(work_experience), params: { work_experience: { location: new_location } }, as: :turbo_stream
        work_experience.reload
        expect(work_experience.location).to eq(new_location)
      end

      it 'renders turbo_stream for successful update' do
        sign_in user
        patch work_experience_path(work_experience), params: { work_experience: { location: 'New Location' } }, as: :turbo_stream

        expect(response).to be_successful
        expect(response.body).to include('turbo-stream')
      end
    end

    context 'with invalid parameters' do
      it 'renders turbo_stream for failed update' do
        sign_in user
        patch work_experience_path(work_experience), params: { work_experience: { invalid_param: 'invalid_value' } }, as: :turbo_stream

        expect(response).to be_successful
        expect(response.body).to include('turbo-stream')
      end
    end
  end

  describe 'DELETE /work_experiences/:id' do
    it 'deletes the work experience' do
      sign_in user
      delete work_experience_path(work_experience), as: :turbo_stream
      expect(WorkExperience.exists?(work_experience.id)).to be_falsey
    end

    it 'renders turbo_stream for successful deletion' do
      sign_in user
      delete work_experience_path(work_experience), as: :turbo_stream

      expect(response).to be_successful
      expect(response.body).to include('turbo-stream')
    end
  end
end
