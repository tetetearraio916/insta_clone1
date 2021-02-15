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
    #複数画像保存の際に、json形式で保存するため対応した
    images { [ Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/IMG_52CBCD9693AC-1.jpeg'), 'spec/fixtures/IMG_52CBCD9693AC-1.jpeg') ] }
    user

    trait :multiple_images do
      images { [ Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/IMG_52CBCD9693AC-1.jpeg'), 'spec/fixtures/IMG_52CBCD9693AC-1.jpeg'), Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/IMG_52CBCD9693AC-1.jpeg'), 'spec/fixtures/IMG_52CBCD9693AC-1.jpeg') ] }
    end

  end
end
