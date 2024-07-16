class Post < ApplicationRecord
  validates :title, presence: true, length: { minimum: 5, maximum: 10 }
  validates :body, presence: true, length: { minimum: 5, maximum: 1000 }
end
