require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let!(:user) { create(:user) }
  let!(:my_post) { create(:post, user: user) }
  let!(:other_post1) { create(:post) }
  let!(:other_post2) { create(:post) }

  describe 'ポスト一覧' do

    context 'ログインしている場合' do
      before do
        login(user)
        user.follow(other_post1.user)
      end
      it 'フォロワーと自分の投稿だけが閲覧できること' do
        visit root_path
        expect(page).to have_content other_post1.content
        expect(page).to have_content my_post.content
        expect(page).not_to have_content other_post2.content
      end
    end

    context 'ログインしていない場合' do
      it '全てのポストが表示されること' do
        visit posts_path
        expect(page).to have_content other_post1.content
        expect(page).to have_content my_post.content
        expect(page).to have_content other_post2.content
      end
    end
  end

  describe 'ポスト投稿' do
    it '画像を投稿できること' do
      login(user)
      visit new_post_path
      within '#posts_form' do
        attach_file '画像', "#{Rails.root}/spec/fixtures/dummy.jpeg"
        fill_in '本文', with: "test"
        click_on '登録する'
      end
      expect(page).to have_content '投稿しました'
      expect(page).to have_content 'test'
    end
  end


  describe 'ポスト更新' do
    before do
      login(user)
    end

    it '自分の投稿に編集ボタンが表示されること' do
      visit root_path
      within "#post-#{my_post.id}" do
        expect(page).to have_css '.edit-button'
      end
    end


    it '他人の投稿には編集ボタンが表示されないこと' do
      user.follow(other_post1.user)
      visit root_path
      within "#post-#{other_post1.id}" do
        expect(page).to_not have_css '.edit-button'
      end
    end


    it '投稿を更新できること' do
      visit edit_post_path(my_post)
      within '#posts_form' do
        attach_file '画像', "#{Rails.root}/spec/fixtures/dummy.jpeg"
        fill_in '本文', with: "update"
        click_on '登録する'
      end
      expect(page).to have_content('投稿を更新しました')
      expect(page).to have_content("update")
    end
  end

  describe '投稿を削除できること' do
    before do
      login(user)
    end

    it '自分の投稿に削除ボタンが表示されること' do
      visit root_path
      expect(page).to have_css '.delete-button'
    end

    it '他人の投稿には削除ボタンが表示されないこと' do
      user.follow(other_post1.user)
      visit root_path
      within "#post-#{other_post1.id}" do
        expect(page).to_not have_css '.delete-button'
      end
    end

    it '投稿を削除できること' do
      visit root_path
      within "#post-#{my_post.id}" do
        page.accept_confirm { find('.delete-button').click }
      end
      expect(page).to have_content("投稿を削除しました")
      expect(page).not_to have_content(my_post.content)
    end
  end

  describe 'ポスト詳細' do
    before do
      login(user)
    end

    it '投稿の詳細画面が閲覧できる' do
      visit post_path(my_post)
      expect(current_path).to eq "/posts/#{my_post.id}"
    end
  end

  describe 'いいね関連' do
    before do
      login(user)
      user.follow(other_post1.user)
    end

    it 'いいねができること' do
      visit root_path
      expect{
        within "#like_area-#{other_post1.id}" do
          find('.like-button').click
        end
        expect(page).to have_css '.unlike-button'
      }.to change(user.like_posts, :count).by(1)
    end

    it 'いいねを外せること' do
      user.like(other_post1)
      visit root_path
      expect{
        within "#like_area-#{other_post1.id}" do
          find('.unlike-button').click
        end
        expect(page).to have_css '.like-button'
      }.to change(user.like_posts, :count).by(-1)
    end
  end
end
