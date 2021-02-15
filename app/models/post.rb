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
class Post < ApplicationRecord
  mount_uploaders :images, ImageUploader
  serialize :images, JSON

  validates :images, presence: true
  validates :content, presence: true, length: { maximum: 1000 }

  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: :user
  has_many :comments, dependent: :destroy
  has_one :notification, as: :subject, dependent: :destroy

  belongs_to :user

  # nameが存在する場合、nameをlike検索する
  scope :post_like, ->(post_content) { where('content LIKE ?', "%#{post_content}%") }
  scope :user_like, ->(name) { joins(:user).where('name LIKE ?', "%#{name}%") }
  scope :comment_like, ->(comment_content) { joins(:comments).where('comments.content LIKE ?', "%#{comment_content}%") }
end
