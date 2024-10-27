# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.create(
  email: "hoge@example.com",
  name: "hoge hoge",
  password: "password",
  password_confirmation: "password"
)
User.create(
  email: "hoge2@example.com",
  name: "hoge2 hoge2",
  password: "password",
  password_confirmation: "password"
)




Category.create(name: "PHP")
Category.create(name: "Java")
Category.create(name: "Next.js")
Category.create(name: "Rails")
Category.create(name: "Apex")


# 記事の作成とランダムカテゴリの割り当て
10.times do |x|
  Post.create(
    title: "title#{x}",
    body: "body#{x}",
    user_id: User.first.id,
    category_id: Category.pluck(:id).sample # ランダムなカテゴリIDを割り当て
  )
end
