class LikesController < ApplicationController

  def create
    @user = User.find(params[:user_id])
    @user.like(post)
  end

  def destroy
    @user = Like.find(params[:id]).user
    @user.unlike(post)
  end
end
