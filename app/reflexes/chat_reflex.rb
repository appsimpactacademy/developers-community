class ChatReflex < StimulusReflex::Reflex
  delegate :current_user, to: :connection

  def open_chat(user_id)
    user2 = User.find(user_id)
    chatroom = find_chatroom(user2)
    messages = chatroom ? chatroom.messages.includes(:user, cover_image_attachment: :blob).order(created_at: :asc) : []

    render_chat_window(chatroom, user2, messages)
  end

  def create_message(data)
    image_key = data['image_key']
    chatroom = find_chatroom(data['otherUserId'])

    if chatroom
      message = create_message_in_chatroom(chatroom, image_key)
      broadcast_message(message, chatroom)
      open_chat(data['otherUserId'])
    end
  end

  def update_messages(other_user)
    user2 = User.find(other_user)
    chatroom = find_chatroom(user2)
    messages = chatroom ? chatroom.messages.includes(:user,  cover_image_attachment: :blob).order(created_at: :asc) : []

    render_message_update(messages, other_user)
  end

  private

  def find_chatroom(user)
    Chatroom.includes(:messages).between_users(current_user, user).first
  end

  def create_message_in_chatroom(chatroom, image_key)
    blob = ActiveStorage::Blob.find_by(key: image_key)
    message = chatroom.messages.build
    message.message = params[:message]['message'] if params.present? && params[:message].present?
    message.user = current_user
    message.cover_image.attach(blob)
    message.save(validate: false)
    return message
  end

  def broadcast_message(message, chatroom)
    ActionCable.server.broadcast("chat_#{chatroom.id}", message.message)
  end

  def render_chat_window(chatroom, user, messages)
    morph "#chat-window-container", render(partial: "chat_window", locals: {
      messages: messages, chatroom: chatroom, other_user: user
    })
  end

  def render_message_update(messages, other_user)
    open_chat(other_user)
    cable_ready['chat'].morph(
      selector: '[data-reflex="click->chat#update_messages"]',
      html: render(partial: 'message', locals: { messages: messages })
    )
    cable_ready.broadcast
  end
end
