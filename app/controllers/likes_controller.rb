class LikesController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    current_user.like(@post)
  end

  def destroy
    #likeのidを取得してから、特定のpostを取得する
    @post = Like.find(params[:id]).post
    current_user.unlike(@post)
  end
end
