class ChatReflex < StimulusReflex::Reflex

  delegate :current_user, to: :connection


  def open_chat(user_id)
    user2 = User.find(user_id)

    chatroom = Chatroom.between_users(current_user, user2).first
    if chatroom
      messages = chatroom.messages.includes(:user).order(created_at: :asc)
    else
      messages = []  # No chatroom found, so no messages to display
    end
    morph "#chat-window-container", render(partial: "chat_window", locals: {
      messages: messages, chatroom: chatroom, other_user: user2
    })
  end

  def create_message(other_user)
    # user2 = User.find(other_user.id)
    chatroom = Chatroom.between_users(current_user, other_user).first
    # Create the message
    Rails.logger.debug("Params: #{params.inspect}")
    Rails.logger.debug("Current User ID: #{current_user.id}")

    if chatroom
      message = chatroom.messages.create(message: params[:message]['message'], user: current_user)


      # Broadcast that everyone on this channel should get messages
      ActionCable.server.broadcast("chat_#{chatroom.id}", message.message)

      open_chat(other_user)
    end
  end

  def update_messages(other_user)
    # Fetch the latest messages and render them
    user2 = User.find(other_user)
    chatroom = Chatroom.between_users(current_user, user2).first
    if chatroom
      messages = chatroom.messages.includes(:user).order(created_at: :asc)
    else
      messages = []  # No chatroom found, so no messages to display
    end
    open_chat(other_user)
    cable_ready['chat'].morph(
      selector: '[data-reflex="click->chat#update_messages"]',
      html: render(partial: 'message', locals: { messages: messages })
    )
    cable_ready.broadcast
  end
end
