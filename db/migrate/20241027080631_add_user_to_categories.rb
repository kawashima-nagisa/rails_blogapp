class AddUserToCategories < ActiveRecord::Migration[7.1]
  def up
    # categories テーブルに user_id カラムを追加
    add_reference :categories, :user, null: true, foreign_key: true

    # デフォルトのユーザーを取得または作成（`password_digest`を使う）
    default_user =
      User.find_or_create_by!(
        email: "default@example.com",
        name: "Default User"
      ) do |user|
        user.password = "password"
        user.password_confirmation = "password"
      end

    # user_id が nil の Category に対して、デフォルトの user_id を設定
    Category.where(user_id: nil).update_all(user_id: default_user.id)
  end

  def down
    # user_id カラムを削除
    remove_reference :categories, :user, foreign_key: true
  end
end
