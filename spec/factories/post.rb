FactoryBot.define do
  factory :post do
    title { Faker::Lorem.characters(number: 5) }  # タイトルが5文字以上になるよう設定
    body { Faker::Lorem.paragraph }
    association :user
    association :category
  end
end
