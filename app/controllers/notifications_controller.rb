class NotificationsController < ApplicationController
  def read
    notification = current_user.notifications.find(params[:id])
    notification.read! if activity.unread?
    redirect_to notification.redirect_path
  end
end
