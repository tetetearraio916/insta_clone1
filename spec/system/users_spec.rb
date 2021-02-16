require 'rails_helper'

RSpec.describe "Users", type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:ohter_post) { create(:post, user: other_user) }

  describe 'ユーザー登録' do
    it 'ユーザー登録が成功すること' do
      visit '/users/new'
      fill_in 'user_name', with: 'tetete'
      fill_in 'user_email', with: 'tetete@example.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      click_on '登録'
      expect(page).to have_content('ユーザーの作成に成功しました')
    end

    it 'ユーザー登録が失敗すること' do
      visit '/users/new'
      fill_in 'user_name', with: 'tetete'
      fill_in 'user_email', with: 'tetete@example.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'passwordpassword'
      click_on '登録'
      expect(page).to have_content('ユーザーの作成に失敗しました')
    end
  end

  describe 'フォロー' do
    it 'フォローができること' do
      login(user)
      visit '/users'
      find("#follow-area-#{other_user.id}").click_on("follow")
      expect(page).to have_css "#unfollow"
    end

    it 'フォローを外せること' do
      login(user)
      user.follow(other_user)
      visit '/users'
      find("#follow-area-#{other_user.id}").click_on("unfollow")
      expect(page).to have_css "#follow"
    end
  end
end
