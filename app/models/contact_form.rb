class ContactForm < ApplicationRecord
  validates :name, presence: true, length: {maximum: 50}
  validates :email,
    presence: true,
    format: {
      with: URI::MailTo::EMAIL_REGEXP,
      message: "有効なメールアドレスを入力してください"
    }
  validates :message, presence: true
end
