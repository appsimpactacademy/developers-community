class Event < ApplicationRecord
  belongs_to :user

  has_many_attached :images

  validates :event_name, :event_type, :start_date,
            :end_date, :start_time, :end_time, :description,
             presence: true

  EVENT_TYPE = ['In Person','Online']

  START_TIME = [ '01:00 AM', '02:00 AM','03:00 AM','04:00 AM','05:00 AM','06:00 AM','07:00 AM','08:00 AM','09:00 AM','10:00 AM','11:00 AM','12:00 PM','01:00 PM','02:00 PM','03:00 PM','04:00 PM','05:00 PM','06:00 PM','07:00 PM','08:00 PM','09:00 PM','10:00 PM','11:00 PM','12:00 AM' ]

  END_TIME = [ '01:00 AM', '02:00 AM','03:00 AM','04:00 AM','05:00 AM','06:00 AM','07:00 AM','08:00 AM','09:00 AM','10:00 AM','11:00 AM','12:00 PM','01:00 PM','02:00 PM','03:00 PM','04:00 PM','05:00 PM','06:00 PM','07:00 PM','08:00 PM','09:00 PM','10:00 PM','11:00 PM','12:00 AM' ]

 def to_calendar_event
    {
      id: id,
      title: event_name,
      start: start_datetime,
      end: end_datetime,
      url: Rails.application.routes.url_helpers.event_path(self)
    }
  end

  private

  def start_datetime
    start_date.strftime('%Y-%m-%dT%H:%M:%S')
  end

  def end_datetime
    end_date.strftime('%Y-%m-%dT%H:%M:%S')
  end
end
