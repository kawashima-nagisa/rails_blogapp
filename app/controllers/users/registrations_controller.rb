require "net/http"
require "uri"

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  RECAPTCHA_SECRET_KEY =
    Rails.application.credentials.dig(:recaptcha, :secret_key)
  RECAPTCHA_SITEVERIFY_URL = "https://www.google.com/recaptcha/api/siteverify"

  def update
    super do |resource|
      if resource.errors.empty?
        Rails.logger.info "画像が添付されましたか？: #{resource.profile_image.attached?}"
      end
    end
  end

  def create
    recaptcha_token = params[:recaptcha_token]

    # reCAPTCHAの検証
    unless verify_recaptcha(recaptcha_token)
      flash[:alert] = "reCAPTCHA認証に失敗しました。もう一度お試しください。"
      redirect_to new_user_registration_path and return
    end

    super
  end

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def verify_recaptcha(token)
    response =
      Net::HTTP.post_form(
        URI.parse(RECAPTCHA_SITEVERIFY_URL),
        { "secret" => RECAPTCHA_SECRET_KEY, "response" => token }
      )
    result = JSON.parse(response.body)
    Rails.logger.info "reCAPTCHA result: #{result}" # デバッグ用ログ
    result["success"] && result["score"].to_f > 0.5
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: %i[name profile_image]
    )
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: %i[twitter facebook github name bio]
    )
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
