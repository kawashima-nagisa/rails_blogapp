FactoryBot.define do
  factory :comment do
    body { "<div>This is a rich text comment.</div>" } # リッチテキストの内容を設定
    association :user
    association :post
  end
end
