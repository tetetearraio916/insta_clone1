require 'rails_helper'

RSpec.describe "Users", type: :system do

  describe 'ユーザー登録' do
    context 'ユーザー情報が正しい場合' do
      it 'ユーザー登録が成功すること' do
        visit '/users/new'
        fill_in 'user_name', with: 'tetete'
        fill_in 'user_email', with: 'tetete@example.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_on '登録'
        expect(current_path).to eq root_path
        expect(page).to have_content('ユーザーの作成に成功しました')
      end
    end

    context 'ユーザー情報が誤りがある場合' do
      it 'ユーザー登録が失敗すること' do
        visit '/users/new'
        fill_in 'user_name', with: ''
        fill_in 'user_email', with: ''
        fill_in 'user_password', with: ''
        fill_in 'user_password_confirmation', with: ''
        click_on '登録'
        expect(page).to have_content('ユーザー名を入力してください')
        expect(page).to have_content('メールアドレスを入力してください')
        expect(page).to have_content('パスワードは3文字以上で入力してください')
        expect(page).to have_content('パスワード(確認)を入力してください')
        expect(page).to have_content('ユーザーの作成に失敗しました')
      end
    end
  end

  describe 'フォロー' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }

    before do
      login(user)
    end

    it 'フォローができること' do
      visit root_path
      expect{
        within "#follow-area-#{other_user.id}" do
          click_on 'follow'
          expect(page).to have_css('#unfollow')
        end
      }.to change(user.follows, :count).by(1)
    end

    it 'フォローを外せること' do
      user.follow(other_user)
      visit root_path
      expect{
        within "#follow-area-#{other_user.id}" do
          click_on 'unfollow'
          expect(page).to have_css('#follow')
        end
      }.to change(user.follows, :count).by(-1)
    end
  end
end
