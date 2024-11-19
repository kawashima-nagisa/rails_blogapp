class Category < ApplicationRecord
  has_many :posts, dependent: :destroy

  # Ransackの検索可能属性を定義
  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end
end
