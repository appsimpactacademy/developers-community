# frozen_string_literal: true

# spec/models/event_spec.rb

require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:user) { create(:user) } # You need to define the user factory or use your actual user creation method

  it 'belongs to a user' do
    user = create(:user) # Assuming you have a user factory
    event = build(:event, user:) # Assuming you have a valid event factory

    expect(event.user).to be_a(User)
  end

  it 'has many attached images' do
    event = build(:event) # Assuming you have a valid event factory
    image = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'download.jpeg'), 'image/jpeg')
    event.images.attach(image)

    expect(event.images).to be_attached
  end

  it 'returns a calendar event hash' do
    event = create(:event, user:)
    calendar_event = event.to_calendar_event

    expect(calendar_event[:id]).to eq(event.id)
    expect(calendar_event[:title]).to eq(event.event_name)
    expect(calendar_event[:start]).to eq(event.send(:start_datetime))
    expect(calendar_event[:end]).to eq(event.send(:end_datetime))
    expect(calendar_event[:url]).to eq(Rails.application.routes.url_helpers.event_path(event))
  end

  it 'calculates start_datetime correctly' do
    event = build(:event, user:, start_date: '2023-11-06', start_time: '10:00 AM') # Corrected time format
    start_datetime = event.send(:start_datetime)

    expect(start_datetime).to eq('2023-11-06T00:00:00')
  end

  it 'calculates end_datetime correctly' do
    event = build(:event, user:, end_date: '2023-11-06', end_time: '11:00 AM') # Corrected time format
    end_datetime = event.send(:end_datetime)

    expect(end_datetime).to eq('2023-11-06T00:00:00')
  end
end
