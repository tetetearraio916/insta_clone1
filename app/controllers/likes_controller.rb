class LikesController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    current_user.like(@post)
    @post.create_notification_by(current_user)
  end

  def destroy
    #likeのidを取得してから、特定のpostを取得する
    @post = Like.find(params[:id]).post
    current_user.unlike(@post)
  end
end
