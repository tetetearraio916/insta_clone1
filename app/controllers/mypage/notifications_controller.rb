class Mypage::NotificationsController < ApplicationController

  def index
    @notifications = Notification.order(id: :desc).page(params[:page]).per(10)
  end

  def read
    notification = current_user.notifications.find(params[:id])
    notification.read! if notification.unread?
    redirect_to notification.redirect_path
  end
end
