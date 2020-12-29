class Mypage::NotificationsController < ApplicationController

  before_action :require_login, only: %i[read]

  def index
    @notifications = current_user.notifications.order(id: :desc).page(params[:page]).per(10)
  end

  def read
    notification = current_user.notifications.find(params[:id])
    notification.read! if notification.unread?
    @notification = notification
    case @notification.action_type.to_sym
      when :commented_to_own_post
        redirect_to post_url(@notification.subject.post, anchor: "comment-#{@notification.subject.id}")
      when :liked_to_own_post
        redirect_to post_url(@notification.subject.post)
      when :followed_me
        redirect_to user_url(@notification.subject.follow)
    end
  end

end
