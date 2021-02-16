FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.word }
    post
    user
  end
end
