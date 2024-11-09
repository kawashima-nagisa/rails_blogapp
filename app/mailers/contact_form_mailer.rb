class ContactFormMailer < ApplicationMailer
  def send_mail(contact_form)
    @contact_form = contact_form
    mail(
      to: Rails.application.credentials.admin_email,
      from: @contact_form.email, # 管理者のメールアドレスを参照
      subject: "管理者さん、お問い合わせが届きました。確認お願いします。"
    )
  end

  def thanks_mail(contact_form)
    @contact_form = contact_form
    mail(to: @contact_form.email, subject: "お問い合わせありがとうございます")
  end
end
