class SavedJobsController < ApplicationController

	def index
		@saved_jobs = current_user.saved_jobs
	end

	def create
		job = Job.find(params[:job_id])

    if current_user.saved_jobs.exists?(job: job)
    	redirect_to saved_jobs_path, alert: 'You have already saved this job.'
    else
    	current_user.saved_jobs.create(job: job)
    	redirect_to saved_jobs_path, notice: 'Job saved successfully.'
    end
  end

  def destroy
  	saved_job = current_user.saved_jobs.find(params[:id])
  	saved_job.destroy

  	redirect_to saved_jobs_path, notice: 'Job removed from saved jobs.'
  end
end
