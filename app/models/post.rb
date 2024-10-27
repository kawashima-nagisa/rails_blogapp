class Post < ApplicationRecord
  validates :title, presence: true, length: {minimum: 5, maximum: 10}
  validates :body, presence: true, length: {minimum: 5, maximum: 1000}
  belongs_to :user

  has_many :comments, dependent: :destroy

  has_noticed_notifications model_name: "Notification"
  has_many :notifications, through: :user

  belongs_to :category

  # Ransackの検索可能属性を定義
  def self.ransackable_attributes(auth_object = nil)
    %w[title body created_at updated_at user_id]
  end

  # 関連モデル（User）の属性を使う場合
  def self.ransackable_associations(auth_object = nil)
    ["user", "category"]
  end
end
