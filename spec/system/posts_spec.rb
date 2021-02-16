require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:my_post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }


  it '投稿一覧が閲覧できる' do
    login(user)
    visit '/'
    expect(current_path).to eq '/'
  end

  it '新規投稿できる' do
    login(user)
    visit '/posts/new'
    attach_file '画像', "#{Rails.root}/spec/fixtures/dummy.jpeg"
    fill_in 'post_content', with: "test"
    click_on '登録する'
    expect(page).to have_content('投稿しました')
  end

  context '自分の投稿に' do
    it '編集ボタンが表示される' do
      user.follow(other_user)
      login(user)
      visit '/'
      within "#post-#{my_post.id}" do
        expect(page).to have_css '#edit'
      end
    end

    it '削除ボタンが表示される' do
      user.follow(other_user)
      login(user)
      visit '/'
      within "#post-#{my_post.id}" do
        expect(page).to have_css '#delete'
      end
    end
  end

  context '他人の投稿に' do

    it '編集ボタンが表示されない' do
      user.follow(other_user)
      login(user)
      visit '/'
      within "#post-#{other_post.id}" do
        expect(page).to_not have_css '#edit'
      end
    end

    it '削除ボタンが表示されない' do
      user.follow(other_user)
      login(user)
      visit '/'
      within "#post-#{other_post.id}" do
        expect(page).to_not have_css '#delete'
      end
    end
  end

  it '投稿を更新できる' do
    login(user)
    visit "/"
    within "#post-#{my_post.id}" do
      click_on 'edit'
    end
    expect(current_path).to eq "/posts/#{my_post.id}/edit"
    attach_file '画像', "#{Rails.root}/spec/fixtures/dummy.jpeg"
    fill_in 'post_content', with: "update"
    click_on '登録する'
    expect(page).to have_content('更新しました')
  end

  it '投稿を削除できる' do
    login(user)
    visit "/"
    within "#post-#{my_post.id}" do
      click_on 'delete'
    end
    expect{
      expect(page.accept_confirm).to eq "本当に削除しますか？"
      expect(page).to have_content "投稿を削除しました"
    }.to change{ Post.count }.by(-1)
  end

  it '投稿の詳細画面が閲覧できる' do
    login(user)
    visit '/'
    click_on 'show'
    expect(current_path).to eq "/posts/#{my_post.id}"
  end

  describe 'いいね関連' do
    it '投稿に対していいねができる' do
      user.follow(other_user)
      login(user)
      visit '/'
      within "#like_area-#{other_post.id}" do
        click_on 'like-button'
      end
      expect(page).to have_css '#unlike-button'
    end

    it '投稿に対していいねを外させる' do
      user.follow(other_user)
      user.like(other_post)
      login(user)
      visit '/'
      within "#like_area-#{other_post.id}" do
        click_on 'unlike-button'
      end
      expect(page).to have_css '#like-button'
    end
  end
end
