class PostsController < ApplicationController
  skip_before_action :require_login, only: :index
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.includes(:images,:user).page(params[:page]).order(id: :desc)
    @users = User.order(id: :desc)
  end

  def new
    @post = Post.new
    @post.images.build

  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      if params[:images].present?
        # フォームで入力されたファイルを一つずつレコードに格納していく
        params[:images][:file].each do |a|
          @image = @post.images.create!(file: a, post_id: @post.id)
        end
      end
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
    @comment = Comment.new
    #新着順で表示、N+1問題に対応するためincludesを用いている
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

  private

  def post_params
    params.require(:post).permit(:content, images_attributes: [:file, :_destroy, :id]).merge(user_id: current_user.id)
  end



  def set_post
    @post = Post.find(params[:id])
  end


end
