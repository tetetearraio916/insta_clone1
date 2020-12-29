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

  after_create_commit :notification_mail

  #comment、likeへの関連付け
  belongs_to :subject, polymorphic: true
  #userへの関連付け
  belongs_to :user

  #enumを使うことによって、数値カラムに対して文字列による名前定義ができる
  enum action_type: { commented_to_own_post: 0, liked_to_own_post: 1, followed_me: 2 }
  enum checked: { unread: false, read: true }




  def what_action_type?
    case action_type.to_sym
    when :commented_to_own_post
      "#{subject.user.name}さんがあなたの投稿にコメントしました"
    when :liked_to_own_post
      "#{subject.user.name}さんがあなたの投稿にいいねしました"
    when :followed_me
      "#{subject.follow.name}さんがあなたをフォローしました"
    end
  end

  def notification_mail
    NotificationMailer.send_notification(self).deliver
  end


end
