# == Schema Information
#
# Table name: relationships
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  follow_id   :bigint
#  followed_id :bigint
#
# Indexes
#
#  index_relationships_on_follow_id                  (follow_id)
#  index_relationships_on_follow_id_and_followed_id  (follow_id,followed_id) UNIQUE
#  index_relationships_on_followed_id                (followed_id)
#
# Foreign Keys
#
#  fk_rails_...  (follow_id => users.id)
#  fk_rails_...  (followed_id => users.id)
#
class Relationship < ApplicationRecord
  belongs_to :follow, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follow_id, presence: true
  validates :followed_id, presence: true
  validates :follow_id, uniqueness: { scope: :followed_id}
end
