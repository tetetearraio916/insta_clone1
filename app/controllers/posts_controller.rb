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
      render :new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to edit_post_path, success: "更新しました"
    else
      flash[:danger] = "更新に失敗しました"　
    　render :edit
  end

  def show
    @post.find(params[:id])
  end

  private

  def post_params
    require(:post).permit(:content, :image)
  end
end
