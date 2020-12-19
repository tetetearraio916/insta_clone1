class Mypage::AccountsController < ApplicationController
  def edit
    @account = User.find(current_user.id)
  end

  def update
    @account = User.find(current_user.id)
    if @account.update(account_params)
      redirect_to edit_mypage_account_url, success: 'プロフィールを更新しました'
    else
      flash.now[:danger] = 'プロフィールの更新にに失敗しました'
      render :edit
    end
  end

  private

  def account_params
    params.require(:user).permit(:name, :avatar)
  end
end
