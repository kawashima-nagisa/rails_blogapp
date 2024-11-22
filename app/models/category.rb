class Category < ApplicationRecord
  has_many :posts, dependent: :destroy
  validates :name, presence: true
  # Ransackの検索可能属性を定義
  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end
end
