class ChatChannel < ApplicationCable::Channel
   def subscribed
    chatroom = Chatroom.find(params[:room].split('_')[1])
    stream_from "chat_#{chatroom.id}"
  end
end
