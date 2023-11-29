# frozen_string_literal: true

class ConnectionsController < ApplicationController
  def index
    @requested_connections = Connection.includes(:requested).where(user_id: current_user.id)
    @received_connections = Connection.includes(:received).where(connected_user_id: current_user.id)
  end

  def create
    @connection = current_user.connections.new(connection_params)
    @connector = User.find(connection_params[:connected_user_id])
    return unless @connection.save

    render_turbo_stream(
      'replace',
      'user-connection-status',
      'connections/create',
      { connector: @connector }
    )
  end

  def update
    @connection = Connection.find(params[:id])
    ActiveRecord::Base.transaction do
      if @connection.update(connection_params) && (@connection.status == 'accepted')
        Chatroom.create(user1: @connection.requested, user2: @connection.received)
        receiver = @connection.received
        receiver.connected_user_ids << @connection.requested.id
        receiver.save

        requester = @connection.requested
        requester.connected_user_ids << @connection.received.id
        requester.save
      end
    end
    render_turbo_stream(
      'replace',
      "connection-status-#{@connection.id}",
      'connections/update',
      { connection: @connection }
    )
  end

  private

  def connection_params
    params.require(:connection).permit(:user_id, :connected_user_id, :status)
  end
end
