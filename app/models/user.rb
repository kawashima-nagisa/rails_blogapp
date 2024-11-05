class User < ApplicationRecord
  has_one_attached :profile_image
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  # 許可された画像形式のバリデーション
  validate :profile_image_content_type
  validate :profile_image_size

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :trackable
  has_many :posts, dependent: :destroy

  has_many :categories, dependent: :destroy

  has_many :comments, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy

  def profile_image_as_thumbnail
    if profile_image.attached? &&
         profile_image.content_type.in?(%w[image/jpeg image/png])
      profile_image.variant(resize_to_limit: [100, 100]).processed
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[email name created_at updated_at]
  end

  def active?
    last_sign_in_at.present? && last_sign_in_at > 15.minutes.ago
  end
end

private

# ファイル形式のバリデーション
def profile_image_content_type
  if profile_image.attached? &&
       !profile_image.content_type.in?(
         %w[image/jpeg image/jpg image/png image/gif image/webp]
       )
    errors.add(:profile_image, ":ファイル形式はJPEG, JPG, PNG, GIF, WEBPのみ許可されています。")
  end
end

# 画像サイズのバリデーション
def profile_image_size
  if profile_image.attached? && profile_image.blob.byte_size > 1.megabyte
    errors.add(:profile_image, ":1MB以下のファイルをアップロードしてください。")
  end
end
