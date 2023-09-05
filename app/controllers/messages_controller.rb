class MessagesController < ApplicationController
  def index
    @received_connections = Connection.includes(:received).where(connected_user_id: current_user.id, status: 'accepted')
    @requested_connections = Connection.includes(:requested).where(user_id: current_user.id, status: 'accepted')

    most_recent_chatroom_query = <<~SQL
      SELECT
        chatrooms.*,
        MAX(messages.created_at) AS most_recent_message_time
      FROM
        chatrooms
      LEFT JOIN
        messages ON chatrooms.id = messages.chatroom_id
      WHERE
        chatrooms.user1_id = :user_id OR chatrooms.user2_id = :user_id
      GROUP BY
        chatrooms.id
      ORDER BY
        most_recent_message_time DESC
      LIMIT
        1
    SQL

    result = ActiveRecord::Base.connection.execute(
      ActiveRecord::Base.send(:sanitize_sql_array, [most_recent_chatroom_query, user_id: current_user.id])
    ).first

    if result
      @chatroom = Chatroom.find(result['id'])
      @messages = @chatroom.messages.includes(:user).order(created_at: :asc)
      @user = @chatroom.user1_id == current_user.id ? @chatroom.user2 : @chatroom.user1
    else
      @chatroom = nil
      @messages = []
      @user = nil
    end
  end
end
