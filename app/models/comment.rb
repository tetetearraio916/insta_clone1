# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#  index_comments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  #バリデーション
  validates :content, presence: true

  #notificationsのアソシエーション
  has_one :notification, as: :subject, dependent: :destroy

  #after_create_commitによってcommentが保存された直後必ず指定したメソッドが発火する
  after_create_commit :create_notifications

  private

  def create_notifications
    Notification.create(subject: self, user: post.user, action: :commented_to_own_post)
  end

end
