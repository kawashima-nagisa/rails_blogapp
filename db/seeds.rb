require 'faker'

# テスト用の固定ユーザー
User.find_or_create_by!(email: "testuser@example.com") do |user|
  user.name = "Test User"
  user.password = "password"
  user.password_confirmation = "password"
end

# Fakerを使って追加のユーザーを生成
4.times do
  User.create!(
    email: Faker::Internet.unique.email,
    name: Faker::Name.name,
    password: 'password',
    password_confirmation: 'password'
  )
end

# カテゴリの生成
categories = %w[PHP Java Next.js Rails Apex]
categories.each do |category_name|
  Category.find_or_create_by!(name: category_name)
end

# 投稿の生成
users = User.all
categories = Category.all

30.times do

  title = Faker::Book.title

  while title.length < 5
    title = Faker::Book.title
  end
  Post.create!(
    title: title,
    body: Faker::Lorem.paragraph(sentence_count: 10),
    user: users.sample,
    category: categories.sample
  )
end

# コメントの生成
posts = Post.all
users = User.all

50.times do
  Comment.create!(
    post: posts.sample,
    user: users.sample,
    body: Faker::Lorem.sentence(word_count: 15)
  )
end

# 問い合わせの生成
10.times do
  ContactForm.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    message: Faker::Lorem.paragraph(sentence_count: 4)
  )
end

# 通知の生成
users.each do |user|
  Notification.create!(
    recipient: user,
    type: "NewCommentNotification",
    params: { message: "あなたの投稿に新しいコメントがあります" }
  )
end

