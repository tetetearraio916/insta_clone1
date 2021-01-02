# == Schema Information
#
# Table name: notifications
#
#  id           :bigint           not null, primary key
#  action_type  :integer          not null
#  checked      :boolean          default("unread"), not null
#  subject_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  subject_id   :bigint
#  user_id      :bigint
#
# Indexes
#
#  index_notifications_on_subject_type_and_subject_id  (subject_type,subject_id)
#  index_notifications_on_user_id                      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Notification < ApplicationRecord

  #comment、likeへの関連付け
  belongs_to :subject, polymorphic: true
  #userへの関連付け
  belongs_to :user

  #enumを使うことによって、数値カラムに対して文字列による名前定義ができる
  enum action_type: { commented_to_own_post: 0, liked_to_own_post: 1, followed_me: 2 }
  enum checked: { unread: false, read: true }

end
