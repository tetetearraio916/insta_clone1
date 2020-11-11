# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  crypted_password :string(255)
#  email            :string(255)      not null
#  name             :string(255)      not null
#  salt             :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
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

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  #likesのデータが入ったpostを直接取得する事ができる
  has_many :like_posts, through: :likes, source: :post

  def own?(object)
    id == object.user_id
  end


  # ポストをいいねする
  def like(post)
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


end
