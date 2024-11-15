require "net/http"
require "uri"
class ContactFormsController < ApplicationController
  def new
    @contact_form = ContactForm.new
  end

  def create
    recaptcha_token = params[:contact_form][:recaptcha_token]
    # reCAPTCHA トークンの検証とContactFormの生成
    if verify_recaptcha(recaptcha_token)
      @contact_form = ContactForm.new(contact_form_params)
      if @contact_form.save
        begin
          ContactFormMailer.send_mail(@contact_form).deliver_now
          ContactFormMailer.thanks_mail(@contact_form).deliver_now
          redirect_to "/", notice: "お問い合わせを受け付けました"
        rescue => e
          Rails.logger.error "メール送信後のエラー: #{e.message}"
          flash[:alert] = "エラーが発生しました。管理者に連絡してください。"
          render :new
        end
      else
        render :new
      end
    else
      flash[:alert] = "reCAPTCHA認証に失敗しました。もう一度お試しください。"
      render :new
    end
  end

  private

  def contact_form_params
    params.require(:contact_form).permit(:name, :email, :message) # recaptcha_tokenは含めない
  end

  def verify_recaptcha(token)
    secret_key = Rails.application.credentials.dig(:recaptcha, :secret_key)
    response =
      Net::HTTP.post_form(
        URI.parse("https://www.google.com/recaptcha/api/siteverify"),
        {"secret" => secret_key, "response" => token}
      )
    result = JSON.parse(response.body)
    Rails.logger.info "reCAPTCHA result: #{result}"

    # reCAPTCHAリクエストのステータスコード確認
    unless result["success"]
      Rails.logger.error "reCAPTCHA認証に失敗しました: #{result["error-codes"]}"
    end
    result["success"] && result["score"].to_f > 0.5
  end
end
