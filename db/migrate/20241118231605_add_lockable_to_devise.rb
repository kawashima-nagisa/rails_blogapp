class AddLockableToDevise < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :failed_attempts, :integer, default: 0, null: false # ログイン失敗回数
    add_column :users, :unlock_token, :string # アカウントロック解除トークン
    add_column :users, :locked_at, :datetime # ロックされる時間

    add_index :users, :unlock_token, unique: true
  end
end
