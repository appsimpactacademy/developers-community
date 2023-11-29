# frozen_string_literal: true

# app/reflexes/profile_reflex.rb
class ProfileViewReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def view_profile(user_id)
    viewed_user = User.find(user_id)
    viewer_user = current_user
    return if viewer_user == viewed_user

    ProfileView.create(viewer: viewer_user, viewed_user:, viewed_at: DateTime.now)
  end
end
