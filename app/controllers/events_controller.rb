class EventsController < ApplicationController
  before_action :set_event, only: %i[edit show update destroy]

  def index
    @events = Event.includes(:user).order(created_at: :desc)
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      redirect_to events_path, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  def show
    respond_to do |format|
      format.html # Render HTML format
      format.json { render json: @event } # Render JSON format
    end
  end

  def update
    if @event.update(event_params)
      redirect_to events_path, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @event.destroy
      redirect_to events_path
    end
  end

  def calendar
    @events = Event.all.map do |event|
      {
        id: event.id,
        title: event.event_name,
        start: event.start_date,
        end: event.end_date,
        # Add other properties as needed
      }
    end

    respond_to do |format|
      format.html
      format.json { render json: @events }
    end
  end


  def create_calendar_event
    @event = current_user.events.build(event_params)
    if @event.save
      render json: { event: @event, message: 'Event created successfully' }, status: :created
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:event_type, :event_name, :start_date, :end_date, :start_time, :end_time, :description, :user_id, images:[])
  end


end
