class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.send_when_notification.subject
  #
  def send_when_notification
    @user = user
    mail to:      user.email,
         subject: "#{@nortification.user}があなたをフォローしました"
         date: "#{@notification.created_at}"
  end
end
