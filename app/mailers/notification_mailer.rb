class NotificationMailer < ApplicationMailer



  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.send_notification.subject
  #
  default from: "instaclon@gmail.com"

  def send_notification(notification)
    @notification = notification
    mail subject: @notification.what_action_type?,
         date: @notification.created_at,
         to: @notification.user.email
  end


end
