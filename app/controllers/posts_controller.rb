class PostsController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]
  before_action :set_post, only: [:edit, :update, :destroy]

  def index
    @posts = if current_user
               current_user.feed.includes(:user).page(params[:page]).order(created_at: :desc)
             else
               Post.includes(:user).page(params[:page]).order(created_at: :desc)
             end
    @users = User.recent(5)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to posts_path, success: '投稿しました'
    else
      flash[:danger] = '投稿に失敗しました'
      render :new
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to root_path, success: '投稿を更新しました'
    else
      flash[:danger] = '投稿の更新に失敗しました'
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path, success: '投稿を削除しました'
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    # 新着順で表示、N+1問題に対応するためincludesを用いている
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

  def search
    @posts = @search_form.search.includes(:user).page(params[:page])
  end

  private

  def post_params
    params.require(:post).permit(:content, images: [])
  end

  def set_post
    @post = current_user.posts.find(params[:id])
  end
end
