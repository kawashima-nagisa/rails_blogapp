# rootページ
crumb :root do
  link '<i class="bi bi-house-fill"></i>Home'.html_safe, root_path
end

# Aboutページ
crumb :about do
  link "About", about_path
end

crumb :contact do
  link "Contacts", new_contact_form_path
end


# 各カテゴリーの詳細ページ（そのカテゴリーに属する投稿の一覧）
crumb :category do |category|
  link "#{category.name}の投稿一覧", category_posts_path(category)
  parent :posts
end

# 投稿一覧ページ（トップレベルの投稿一覧ページ）
crumb :posts do
  link "投稿一覧", posts_path
  parent :root
end

# 各投稿の詳細ページ（単一の投稿ページ）
crumb :post do |post|
  link post.title, post_path(post) # 投稿のタイトルとリンク
  if post.category
    parent :category, post.category
  else
    parent :posts
  end
end

# ユーザープロフィールページ
crumb :user_profile do |user|
  link "#{user.name}さんのプロフィール", user_path(user) # ユーザー名とリンク
  parent :root
end

# ユーザープロフィール編集ページ
crumb :edit_user_profile do |user|
  link "プロフィール編集", edit_user_registration_path # プロフィール編集へのリンク
  # parent :root # プロフィールページを親に指定
  parent :user_profile, user
end

# パスワード編集ページ
crumb :edit_user_password do |user|
  link "パスワード編集", edit_user_password_path # プロフィール編集へのリンク
  # parent :root # プロフィールページを親に指定
  parent :user_profile, user
end
