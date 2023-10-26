class MyJobsController < ApplicationController
  def index
    @jobs = current_user.jobs.order(created_at: :desc)
  end
end
