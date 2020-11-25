class UsersController < ApplicationController
  skip_before_action :require_login, only: [:index, :new, :create, :show]

  def index
    @users = User.order(id: :desc).page(params[:page]).per(10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # postsへリダイレクト
      auto_login(@user)
      redirect_to root_url, success: 'ユーザーの作成に成功しました'
    else
      flash[:danger] = 'ユーザーの作成に失敗しました'
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def edit
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
