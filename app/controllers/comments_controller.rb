class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]


  def create
    @comment = current_user.comments.build(comment_params)
    NotificationMailer.with(user_from: current_user, user_to: @comment.post.user, comment: @comment).comment_post.deliver_later if @comment.save && current_user.notification_on_comment?
  end



  def edit
  end

  def update
    @comment.update(comment_update_params)
  end

  def destroy
    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:content).merge(post_id: params[:post_id])
  end

  def comment_update_params
    params.require(:comment).permit(:content)
  end


  def set_comment
    @comment = current_user.comments.find(params[:id])
  end

end
