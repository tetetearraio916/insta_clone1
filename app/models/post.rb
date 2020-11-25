# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  content    :text(65535)
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
  validates :content, presence: true, length: { maximum: 1000 }
  has_many :comments, dependent: :destroy
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images
  belongs_to :user


  #ログインしているユーザーとそのユーザーのフォロワーのポストだけを取得
  def login_posts
    post_all = Post.includes(:images,:user)
    user = User.find(current_user.id)
    follow_users = user.follows.all
    post_all.where(user_id: follow_users).order("created_at DESC").page(params[:page])
  end


end
