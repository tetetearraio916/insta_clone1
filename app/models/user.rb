# == Schema Information
#
# Table name: users
#
#  id                      :bigint           not null, primary key
#  avatar                  :string(255)
#  crypted_password        :string(255)
#  email                   :string(255)      not null
#  name                    :string(255)      not null
#  notification_on_comment :boolean          default(FALSE)
#  notification_on_follow  :boolean          default(FALSE)
#  notification_on_like    :boolean          default(FALSE)
#  salt                    :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  mount_uploader :avatar, ImageUploader



  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

   has_many :likes, dependent: :destroy
  #likesのデータが入ったpostを直接取得する事ができる
  has_many :like_posts, through: :likes, source: :post

  #notificationのアソシエーション
  has_many :notifications, dependent: :destroy

  has_many :follow_relationships, foreign_key: "follow_id", class_name: "Relationship", dependent: :destroy
  has_many :follows, through: :follow_relationships, source: :followed
  has_many :followed_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followed, through: :followed_relationships, source: :follow

  #defで関数を定義するかscopeを使うかは好みの問題



  def follow(other_user)
    follow_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    follow_relationships.find_by(followed_id: other_user.id).destroy
  end

  def follow?(other_user)
    follows.include?(other_user)
  end

  def own?(object)
    id == object.user_id
  end

  # ポストをいいねする
  def like(post)
    #Like.newせずとも新しいレコードがインサートする。とても便利なメソッド。
    like_posts << post
  end

  # ポストのいいねを解除する
  def unlike(post)
    like_posts.destroy(post)
  end

  #その投稿にいいねがあるかどうか
  def like?(post)
    like_posts.include?(post)
  end


  def feed
    #Postsテーブルのuser_idカラムからuserがフォローしているidの配列を取得しているかつその配列にcurrent_userのidも配列に加えてSQL内を検索している。
    Post.where(user_id: follow_ids << id)
  end



end
