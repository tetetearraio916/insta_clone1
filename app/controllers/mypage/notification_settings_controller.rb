class Mypage::NotificationSettingsController < ApplicationController
  def edit
    @user = User.find(current_user.id)
  end
end
