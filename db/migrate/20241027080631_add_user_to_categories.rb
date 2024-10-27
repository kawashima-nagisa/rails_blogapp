class AddUserToCategories < ActiveRecord::Migration[7.1]
  def up
    add_reference :categories, :user, null: true, foreign_key: true

    # デフォルトのユーザーを取得して設定
    default_user = User.first
    Category.where(user_id: nil).update_all(user_id: default_user.id)

    # `user_id`のnull制約を追加
    change_column_null :categories, :user_id, false
  end

  def down
    remove_reference :categories, :user
  end
end
