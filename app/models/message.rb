class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chatroom

  def sent_by?(user)
    self.user == user
  end
end
