# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Jobs', type: :request do
  let(:user) { create(:user) }
  let(:job_category) { create(:job_category) }
  let(:job) { create(:job, user:, job_category:) }

  before { sign_in(user) }

  describe 'GET /jobs' do
    it 'renders the index template' do
      get jobs_path
      expect(response).to render_template(:index)
    end

    it 'assigns jobs based on job_category if present' do
      get jobs_path, params: { job_category: job_category.name }
      expect(assigns(:jobs)).to be_an(ActiveRecord::Relation)
    end

    it 'assigns jobs without filtering if job_category is not present' do
      get jobs_path
      expect(assigns(:jobs)).to be_an(ActiveRecord::Relation)
    end

    it 'displays a flash alert if no jobs are available in the specified category' do
      get jobs_path, params: { job_category: 'NonexistentCategory' }
      expect(flash.now[:alert]).to be_present
    end
  end

  describe 'GET /jobs/new' do
    it 'renders the new template' do
      get new_job_path, as: :turbo_stream
      expect(response).to render_template(:new)
    end
  end

  describe 'POST /jobs' do
    it 'creates a new job' do
      expect do
        post jobs_path, params: { job: attributes_for(:job, job_category_id: job_category.id) }
      end.to change(Job, :count).by(1)
      expect(response).to redirect_to(jobs_path)
    end
  end

  describe 'GET /jobs/:id/edit' do
    it 'renders the edit template' do
      get edit_job_path(job), as: :turbo_stream
      expect(response).to render_template(:edit)
    end
  end

  describe 'GET /jobs/:id' do
    it 'renders the show template' do
      get job_path(job)
      expect(response).to render_template(:show)
    end
  end

  describe 'PATCH /jobs/:id' do
    it 'updates the job' do
      patch job_path(job), params: { job: { title: 'Updated Title' } }
      expect(job.reload.title).to eq('Updated Title')
      expect(response).to redirect_to(jobs_path)
    end
  end

  describe 'DELETE /jobs/:id' do
    it 'destroys the job' do
      job # Ensure the job is created before attempting to destroy it
      expect do
        delete job_path(job)
      end.to change(Job, :count).by(-1)
      expect(response).to redirect_to(jobs_path)
    end
  end
end
