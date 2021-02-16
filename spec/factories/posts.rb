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
FactoryBot.define do
  factory :post do
    content { Faker::Lorem.word }
    #複数画像保存の際に、json形式で保存するため対応した([]に値を入れなければならない)
    images { [File.open("#{Rails.root}/spec/fixtures/dummy.jpeg")] }
    user

    trait :multiple_images do
      images { [File.open("#{Rails.root}/spec/fixtures/dummy.jpeg"), File.open("#{Rails.root}/spec/fixtures/dummy.jpeg")] }
    end

  end
end
