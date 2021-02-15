class LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    # withメソッドによって、paramsに新しいキーと値を追加している？リファレンスの情報が転がってないのでよくわかっていない
    # NotificationMailerで作成したメソッド
    # deliver_laterで非同期にメール送信できるらしい
    NotificationMailer.with(user_from: current_user, user_to: @post.user, post: @post).like_post.deliver_later if current_user.like(@post) && current_user.notification_on_like?
  end

  def destroy
    # likeのidを取得してから、特定のpostを取得する
    @post = Like.find(params[:id]).post
    current_user.unlike(@post)
  end
end
