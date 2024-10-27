class AddCategoryToPosts < ActiveRecord::Migration[7.1]
  def change
    # カラムを一時的にnull: trueで追加
    add_reference :posts, :category, foreign_key: true, null: true

    # デフォルトカテゴリーを設定（未分類など）
    default_category = Category.find_or_create_by(name: "未分類")

    # 既存のレコードをデフォルトカテゴリーに更新
    Post.where(category_id: nil).update_all(category_id: default_category.id)

    # 最後にnull制約を追加
    change_column_null :posts, :category_id, false
  end
end
