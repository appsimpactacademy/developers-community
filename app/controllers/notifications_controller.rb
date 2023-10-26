class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.includes(:user, :item)
    @notifications.update(viewed: true)
  end

  def destroy
    @notification = current_user.notifications.find(params[:id])
    if @notification.destroy
      redirect_to notifications_path, alert: 'Notification was successfully destroyed.'
    end
  end

end
