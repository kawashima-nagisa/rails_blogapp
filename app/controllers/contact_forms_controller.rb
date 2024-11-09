class ContactFormsController < ApplicationController
  def new
    @contact_form = ContactForm.new
  end

  def create
    @contact_form = ContactForm.new(contact_form_params)
    if @contact_form.save
      ContactFormMailer.send_mail(@contact_form).deliver_now
      ContactFormMailer.thanks_mail(@contact_form).deliver_later(
        wait: 5.seconds
      )
      redirect_to root_path, notice: "お問い合わせを受け付けました"
    else
      render :new
    end
  end

  private

  def contact_form_params
    params.require(:contact_form).permit(:name, :email, :message)
  end
end
