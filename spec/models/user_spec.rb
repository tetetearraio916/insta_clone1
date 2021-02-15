# == Schema Information
#
# Table name: users
#
#  id                      :bigint           not null, primary key
#  avatar                  :string(255)
#  crypted_password        :string(255)
#  email                   :string(255)      not null
#  name                    :string(255)      not null
#  notification_on_comment :boolean          default(TRUE)
#  notification_on_follow  :boolean          default(TRUE)
#  notification_on_like    :boolean          default(TRUE)
#  salt                    :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it 'ユーザー名、メール、パスワードが存在すれば有効であること' do
      expect(build(:user)).to be_valid
    end

    it 'ユーザー名が存在しなければ無効であること' do
      user = build(:user, name: nil)
      user.valid?
      expect(user.errors[:name]).to include("を入力してください")
    end

    it 'メールが存在しなければ無効であること' do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include("を入力してください")
    end

    it 'パスワードが存在しなければ無効であること' do
      user = build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to include("は3文字以上で入力してください")
    end

    it 'パスワード確認が存在しなければは無効であること' do
      user = build(:user, password_confirmation: nil)
      user.valid?
      expect(user.errors[:password_confirmation]).to include("を入力してください")
    end

    it 'ユーザー名が一意であること' do
      create(:user, name: "taro")
      user = build(:user, name: "taro")
      user.valid?
      expect(user.errors[:name]).to include("はすでに存在します")
    end

    it 'メールが一意であること' do
      create(:user, email: "taro@example.com")
      user = build(:user, email: "taro@example.com")
      user.valid?
      expect(user.errors[:email]).to include("はすでに存在します")
    end
  end

  describe 'アソシエーション' do
    let!(:post) { create(:post) }
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }

    describe '全ての関連付けに対して' do
      let!(:my_post) { create(:post, user: user) }
      let!(:other_post) { create(:post, user: other_user) }

      it '関連付けしたリソースがそのユーザーのものであること' do
        expect(user.own?(my_post)).to be_truthy
      end

      it '関連付けしたリソースがそのユーザーのものでないこと' do
        expect(user.own?(other_post)).to be_falsey
      end


    end

    describe 'フォロー関連' do

      it 'ユーザーをフォローすること' do
        expect{user.follow(other_user)}.to change{ Relationship.count }.by(1)
      end

      it 'ユーザーをアンフォローすること' do
        user.follow(other_user)
        expect{user.unfollow(other_user)}.to change{ Relationship.count }.by(-1)
      end

      it 'ユーザーが他のユーザーをフォローしているかがわかること' do
        user.follow(other_user)
        expect(user.follow?(other_user)).to be_truthy
      end

      it 'ユーザーが他のユーザーをフォローしていないことがわかること' do
        expect(user.follow?(other_user)).to be_falsey
      end

      it '自分とフォローしたユーザーの投稿が取得できること' do
        user.follow(other_user)
        expect(user.feed.count).to eq(user.posts.count + other_user.posts.count)
      end
    end

    describe 'いいね関連' do

      it '投稿にいいねをすること' do
        expect{user.like(post)}.to change{ Like.count }.by(1)
      end

      it 'いいねした投稿を解除する' do
        user.like(post)
        expect{user.unlike(post)}.to change{ Like.count }.by(-1)
      end

      it 'ユーザーがその投稿にいいねしていることがわかること' do
        user.like(post)
        expect(user.like?(post)).to be_truthy
      end

      it 'ユーザーがその投稿にいいねしていないことがわかること' do
        expect(user.like?(post)).to be_falsey
      end
    end
  end
end
