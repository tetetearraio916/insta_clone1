class NotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.send_notification.subject
  #
  default from: "instaclon@example.com"

  def send_notification(notification)
    @notification = notification
    mail subject: what_action_type?(@notification)
         date: @notification.created_at
         to: @notification.user.email
  end

  private

  def what_action_type?(notification)
    case notification.action_type.to_sym
      when :commented_to_own_post
        "#{notification.subject.user.name}さんがあなたの投稿にコメントしました"
      when :liked_to_own_post
        "#{notification.suject.user.name}さんがあなたの投稿にいいねしました"
      when :followed_me
        "#{notification.subject.follow.name}さんがあなたをフォローしました"
    end
  end

end
