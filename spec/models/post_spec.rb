# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  content    :text(65535)      not null
#  images     :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'バリデーション' do
    it '投稿内容、画像が存在すれば有効であること' do
      expect(build(:post)).to be_valid
    end

     it '複数画像でも有効であること' do
      expect(build(:post, :multiple_images )).to be_valid
    end

    it '投稿内容が存在しなければ無効であること' do
      post = build(:post, content: nil)
      post.valid?
      expect(post.errors[:content]).to include("を入力してください")
    end

    it '投稿内容が1000文字以上であれば無効であること' do
      post = build(:post, content: 'a'*1001)
      post.valid?
      expect(post.errors[:content]).to include("は1000文字以内で入力してください")
    end

    it '画像が存在しなければ無効であること' do
      post = build(:post, images: nil)
      post.valid?
      expect(post.errors[:images]).to include("を入力してください")
    end
  end

  describe '投稿を検索する' do
    let(:user) { create(:user, name: 'doraemon') }
    let(:post) { create(:post, content: 'abcde', user: user) }
    let(:comment) { create(:comment, content: 'hoge', post: post) }

    context '投稿内容から' do
      it '入力文字と一致する投稿が存在すれば返すこと' do
        expect(Post.post_like('ab')).to include(post)
      end

      it '入力文字と一致する投稿が存在しなければ返さない' do
        expect(Post.post_like('abd')).to be_empty
      end
    end

    context 'ユーザー名から' do
      it '入力文字と一致するユーザーが存在すれば投稿を返すこと' do
        expect(Post.user_like('dora')).to eq(user.posts)
      end

      it '入力文字と一致するユーザーが存在しなければ投稿を返さないこと' do
        expect(Post.user_like('dore')).to be_empty
      end
    end

    context 'コメントから' do
      it '入力文字と一致するコメントが存在すれば投稿を返すこと' do
        expect(Post.comment_like('ho')).to include(comment.post)
      end

      it '入力文字と一致するコメントが存在すれば投稿を返すこと' do
        expect(Post.comment_like('hob')).to be_empty
      end
    end
  end
end
