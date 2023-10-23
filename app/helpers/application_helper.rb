module ApplicationHelper
  def get_connection_status(user)
    return nil if current_user == user
    
    current_user.my_connection(user).last.status
  end

  def flash_class(level)
    case level
    when :notice then 'alert alert-success'
    when :alert then 'alert alert-danger' 
    end
  end
end
