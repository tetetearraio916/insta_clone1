class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]
  def index
  end

  def create
    @post = Post.find(params[:post_id])
    #投稿に紐づいたコメントを作成
    @comment = @post.comments.build(comment_params)
    @comment.user_id = current_user.id
    @comment.save
  end

  def

  def edit
     @post = Post.find(params[:post_id])
  end

  def update
    @comment.update(comment_params)
  end

  def destroy
    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id, :user_id)
  end


  def set_comment
    @comment = Comment.find(params[:id])
  end

end
