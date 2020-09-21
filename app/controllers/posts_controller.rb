class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update]

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to posts_path, success: "投稿しました"
    else
      flash[:danger] = "投稿に失敗しました"
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to edit_post_path, success: "更新しました"
    else
      flash[:danger] = '更新に失敗しました'
    　render :edit
    end
  end

  def show
  end

  private

  def post_params
    params.require(:post).permit(:content, :image)
  end

  def set_post
    @post = current_user.posts.find(params[:id])
  end
end
