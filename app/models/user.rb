class User < ApplicationRecord
  has_one_attached :profile_image
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :twitter,
            :facebook,
            :github,
            format: {
              with: URI::DEFAULT_PARSER.make_regexp,
              message: "有効なURLを入力してください"
            },
            allow_blank: true

  # 許可された画像形式のバリデーション
  validate :profile_image_content_type
  validate :profile_image_size
  validates :name, presence: true, length: { maximum: 20 }
  validates :password, length: { in: 6..10 }, if: -> { password.present? }
  validates :email,
            format: {
              with: URI::MailTo::EMAIL_REGEXP
            },
            uniqueness: true

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :trackable
  has_many :posts, dependent: :destroy

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

  # 現在のセッションのログイン時刻が24時間以内,前回のログインから24時間以内であればアクティブとする
  def active?
    (current_sign_in_at && current_sign_in_at > 24.hours.ago) ||
      (last_sign_in_at && last_sign_in_at > 24.minutes.ago)
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
