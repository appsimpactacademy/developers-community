# frozen_string_literal: true

class MyEventsController < ApplicationController
  def index
    @events = current_user.events.order(created_at: :desc)
  end
end
