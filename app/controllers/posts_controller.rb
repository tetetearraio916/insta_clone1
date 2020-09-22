class PostsController < ApplicationController
  skip_before_action :require_login, only: :index
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all.order(id: :desc)
    @users = User.all.order(id: :desc)
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
      redirect_to root_path, success: "更新しました"
    else
      flash[:danger] = '更新に失敗しました'
    　render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path
  end

  def show
    @user = User.find(@post.user_id)
  end

  private

  def post_params
    params.require(:post).permit(:content, :image)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
