require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  let(:user) { create(:user) }

  describe 'ログイン' do
    it 'ユーザーがログイン後投稿一覧画面にリダイレクトされること' do
      visit '/login'
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'password'
      click_on 'login' #ヘッダーのログインに反応してしまうためid指定に変更
      expect(current_path).to eq root_path
    end
  end

  describe 'ログアウト' do
    it 'ユーザーがログアウト後ログイン画面にリダイレクトされること' do
      login(user)
      click_on 'ログアウト'
      expect(current_path).to eq '/login'
    end
  end
end
