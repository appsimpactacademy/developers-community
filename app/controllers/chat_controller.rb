class ChatController < ApplicationController
  def index
    @other_user = User.find(params[:user_id])  # The other user in the chat

    @chatroom = Chatroom.between_users(current_user, @other_user).first

    if @chatroom
      messages = @chatroom.messages.includes(:user).order(created_at: :asc)
    else
      messages = []  # No chatroom found, so no messages to display
    end

    render locals: { messages: messages, other_user: @other_user }
  end
end
