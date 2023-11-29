# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[edit show update destroy]

  def index
    @events = Event.includes(:user).order(created_at: :desc)
  end

  def new
    @event = Event.new
  end

  def edit; end

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      redirect_to events_path, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  def show; end

  def update
    if @event.update(event_params)
      redirect_to events_path, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    return unless @event.destroy

    redirect_to events_path
  end

  def calendar_events
    @events = Event.all
    respond_to do |format|
      format.html
      format.json { render json: @events.map(&:to_calendar_event) }
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:event_type, :event_name, :start_date, :end_date, :start_time, :end_time,
                                  :description, :user_id, images: [])
  end
end
