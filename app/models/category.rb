class Category < ApplicationRecord
  belongs_to :user

  # Ransackの検索可能属性を定義
  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end
end
