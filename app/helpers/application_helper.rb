module ApplicationHelper
  def get_connection_status(user)
    return nil if current_user == user
    
    current_user.my_connection(user).last.status
  end
end
