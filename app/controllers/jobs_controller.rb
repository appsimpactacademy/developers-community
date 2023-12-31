# frozen_string_literal: true

class JobsController < ApplicationController
  before_action :set_jobs, only: %i[edit show update destroy]

  def index
    if params[:job_category].present?
      @jobs = Job.joins(:job_category)
                 .where('job_categories.name = ?', params[:job_category])
                 .order(created_at: :desc)
                 .page(params[:page])
                 .per(4)
      flash.now[:alert] = "No jobs available in the #{params[:job_category]} category." if @jobs.empty?
    else
      @jobs = Job.includes(:job_category).order(created_at: :desc).page(params[:page]).per(4)
    end
  end

  def new
    @job = Job.new
    @pages = Page.all
  end

  def create
    @job = current_user.jobs.build(job_params)
    return unless @job.save

    redirect_to jobs_path
  end

  def edit
    @pages = Page.all
  end

  def show; end

  def update
    if @job.update(job_params)
      redirect_to jobs_path
    else
      render :edit
    end
  end

  def destroy
    return unless @job.destroy

    redirect_to jobs_path
  end

  private

  def set_jobs
    @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(:title, :employee_type, :location, :salary, :description, :qualification, :status,
                                :job_category_id, :user_id, :page_id)
  end
end
