FactoryBot.define do
  factory :notification do
    recipient { association(:user) }
    type { "NewCommentNotification" }
    params { {message: "あなたの投稿に新しいコメントがあります"} }
    read_at { nil }
  end
end
