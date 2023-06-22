module ApplicationHelper
  def get_connection_status(current_user, user)
    current_user.connections.find_by(connected_user_id: user.id).status
  end

  def get_the_receiver(user_id)
    User.find(user_id)
  end

  def get_the_requester(user_id)
    User.find(user_id)
  end
end
