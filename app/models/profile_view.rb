class ProfileView < ApplicationRecord
  belongs_to :viewer, class_name: 'User', foreign_key: 'viewer_id'
  belongs_to :viewed_user, class_name: 'User', foreign_key: 'viewed_user_id'

  include Notificable

  # # for notification
  def user_ids
    User.where(id: self.viewed_user.id).ids
    #User.all.ids
  end
end
