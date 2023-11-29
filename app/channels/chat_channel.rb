class ChatChannel < ApplicationCable::Channel
  def subscribed
    chatroom_id = params[:room].split('_')[1]
    chatroom = Chatroom.find_by(id: chatroom_id) if chatroom_id.present?

    if chatroom
      stream_from "chat_#{chatroom.id}"
    else
      reject # This will prevent the subscription if the chatroom is not found.
    end
  end
end
