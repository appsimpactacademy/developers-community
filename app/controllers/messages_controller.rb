class MessagesController < ApplicationController
  def index
    @received_connections = Connection.includes(:received).where(connected_user_id: current_user.id, status: 'accepted')
    @requested_connections = Connection.includes(:requested).where(user_id: current_user.id, status: 'accepted')

    # Find chatrooms where the current user is involved
    user1_chatrooms = current_user.user1_chatrooms
    user2_chatrooms = current_user.user2_chatrooms

    # Combine and flatten the chatrooms
    all_chatrooms = (user1_chatrooms + user2_chatrooms).uniq
    @chatroom = nil
    most_recent_message_time = nil

    all_chatrooms.each do |chatroom|
      recent_message_time = chatroom.messages.maximum(:created_at)
      
      if recent_message_time && (most_recent_message_time.nil? || recent_message_time > most_recent_message_time)
        most_recent_message_time = recent_message_time
        @chatroom = chatroom
      else
        @chatroom = chatroom
      end
    end

    if @chatroom
      @messages = @chatroom.messages.includes(:user).order(created_at: :asc)
      @user = @chatroom.user1_id == current_user.id ? @chatroom.user2 : @chatroom.user1
    else
      @messages = []
      @user = nil
    end
  end
end
