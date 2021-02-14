FactoryBot.define do
  factory :post do
    association :user
    content { Faker::Lorem.word }
  end
end
