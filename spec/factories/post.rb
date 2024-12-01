FactoryBot.define do
  factory :post do
    title { "ValidTitle" } # 5文字以上10文字以内のタイトル
    body { "This is a valid body text." } # 5～1000文字以内の本文
    association :user
    association :category
  end
end
