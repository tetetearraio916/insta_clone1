# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_likes_on_post_id              (post_id)
#  index_likes_on_user_id              (user_id)
#  index_likes_on_user_id_and_post_id  (user_id,post_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  #post_idとuser_idの組が１組しかないvalidate
  validates :user_id, uniqueness: {scope: :post_id}

  #notificationsのアソシエーション
  has_one :notification, as: :subject, dependent: :destroy

  #after_create_commitによってcommentが保存された直後必ず指定したメソッドが発火する
  after_create_commit :create_notifications

  private

  def create_notifications
    Notification.create(subject: self, user: post.user, action: :liked_to_own_post)
  end
end
