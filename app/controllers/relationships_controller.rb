class RelationshipsController < ApplicationController

  before_action :set_user

  def create
    NotificationMailer.with(user_from: current_user, user_to: @user).follow.deliver_later if current_user.follow(@user) && current_user.on_follow?
  end

  def destroy
    current_user.unfollow(@user)
  end

  private

  def set_user
    @user = User.find(params[:relationship][:followed_id])
  end
end
