class PostsController < ApplicationController
  def index
    @post = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to posts_path, success: "投稿しました"
    else
      flash[:danger] = "投稿に失敗しました"
      render new
  end

  def edit
    @post = Post.find(params)
  end

  def show
  end

  private

  def post_params
    require(:post).permit(:content, :image)
  end
end
