# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MyJobs', type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe 'GET /my_jobs' do
    it 'returns a successful response' do
      get user_my_jobs_path(user)
      expect(response).to be_successful
    end

    context 'with jobs for the current user' do
      let!(:jobs) { create_list(:job, 3, user:) }
      let!(:other_user_job) { create(:job) } # Job belonging to another user

      before { get user_my_jobs_path(user) }

      it 'assigns jobs for the current user' do
        expect(assigns(:jobs)).to match_array(jobs)
        expect(assigns(:jobs)).not_to include(other_user_job)
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end
    end
  end
end
