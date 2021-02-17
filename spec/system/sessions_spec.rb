require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  let(:user) { create(:user) }

  describe 'ログイン' do
    context '認証情報が正しい場合' do
      it 'ログインできること' do
        visit '/login'
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password'
        click_on 'login' #ヘッダーのログインに反応してしまうためid指定に変更(within使った方がよいかもしれない)
        expect(current_path).to eq root_path
        expect(page).to have_content 'ログインしました'
      end
    end

    context '認証情報が誤りがある場合' do
      it 'ログインできないこと' do
        visit '/login'
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'misspassword'
        click_on 'login' #ヘッダーのログインに反応してしまうためid指定に変更
        expect(current_path).to eq login_path
        expect(page).to have_content 'ログインに失敗しました'
      end
    end
  end

  describe 'ログアウト' do
    it 'ユーザーがログアウト後ログイン画面にリダイレクトされること' do
      login(user)
      click_on 'ログアウト'
      expect(current_path).to eq '/login'
      expect(page).to have_content 'ログアウトしました'
    end
  end
end
