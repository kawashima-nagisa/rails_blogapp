# app/controllers/users/registrations_controller.rb
require "net/http"
require "uri"

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  RECAPTCHA_SECRET_KEY = Rails.application.credentials.dig(:recaptcha, :secret_key)
  RECAPTCHA_SITEVERIFY_URL = "https://www.google.com/recaptcha/api/siteverify"

  def update
    super do |resource|
      if resource.errors.empty?
        Rails.logger.info "画像が添付されましたか？: #{resource.profile_image.attached?}"
      else
        Rails.logger.error "更新エラー: #{resource.errors.full_messages}"
      end
    end
  end

  def create
    recaptcha_token = params[:recaptcha_token]

    unless verify_recaptcha(recaptcha_token)
      flash[:alert] = "reCAPTCHA認証に失敗しました。もう一度お試しください。"
      redirect_to new_user_registration_path and return
    end

    super
  end

  protected

  # reCAPTCHAの検証
  def verify_recaptcha(token)
    response = Net::HTTP.post_form(
      URI.parse(RECAPTCHA_SITEVERIFY_URL),
      { "secret" => RECAPTCHA_SECRET_KEY, "response" => token }
    )
    result = JSON.parse(response.body)
    Rails.logger.info "reCAPTCHA result: #{result}" # デバッグ用ログ
    result["success"] && result["score"].to_f > 0.5
  end

  # アカウント更新時のパラメータの許可
  def configure_permitted_parameters
    # profile_imageを配列で許可
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [:name, :remove_profile_image, :twitter, :facebook, :github, :bio, profile_image: []]
    )
  end

  
  # パスワードなしでユーザー情報を更新するためのメソッド
  def update_resource(resource, params)
    # `remove_profile_image`が「1」の場合はプロフィール画像を削除
    resource.profile_image.purge if params[:remove_profile_image] == "1"

    # 新しい画像がアップロードされている場合にBlob IDを取得し、アタッチ
    if params[:profile_image].is_a?(Array) && params[:profile_image][1].present?
      blob = ActiveStorage::Blob.find_signed(params[:profile_image][1])
      resource.profile_image.attach(blob) if blob.present?
    end

    # パスワードなしで他の属性を更新
    resource.update_without_password(params.except(:remove_profile_image, :profile_image))
  end
end
