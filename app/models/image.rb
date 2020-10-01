# == Schema Information
#
# Table name: images
#
#  id         :bigint           not null, primary key
#  url        :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint
#
# Indexes
#
#  index_images_on_post_id  (post_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#
class Image < ApplicationRecord
  belongs_to :post
  mount_uploader :url, ImageUploader
end
