# == Schema Information
#
# Table name: notifications
#
#  id           :bigint           not null, primary key
#  action       :integer          not null
#  checked      :boolean          default(FALSE), not null
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
end
