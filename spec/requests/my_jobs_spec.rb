# spec/requests/my_jobs_spec.rb
require 'rails_helper'

RSpec.describe 'MyJobs', type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe 'GET /my_jobs' do
    it 'returns a successful response' do
      get user_my_jobs_path(user)
      expect(response).to be_successful
    end

    it 'assigns jobs for the current user' do
      jobs = create_list(:job, 3, user: user)
      other_user_job = create(:job) # Job belonging to another user

      get user_my_jobs_path(user)
      expect(assigns(:jobs)).to match_array(jobs)
      expect(assigns(:jobs)).not_to include(other_user_job)
    end

    it 'renders the index template' do
      get user_my_jobs_path(user)
      expect(response).to render_template(:index)
    end
  end
end
