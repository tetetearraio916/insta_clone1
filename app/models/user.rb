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
  has_many :comments, dependent: :destroy

  has_many :follow_relationships, foreign_key: "follow_id", class_name: "Relationship", dependent: :destroy
  has_many :follows, through: :follow_relationships, source: :followed
  has_many :followed_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followed, through: :followed_relationships, source: :follow

  def follow(other_user)
    follow_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    relationship = follow_relationships.find(followed_id: other_user.id)
    relationship.destroy
  end

  def follow?(other_user)
    follows.include?(other_user)
  end

end
