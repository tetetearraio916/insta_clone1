class NotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.send_notification.subject
  #
  def send_notification
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
