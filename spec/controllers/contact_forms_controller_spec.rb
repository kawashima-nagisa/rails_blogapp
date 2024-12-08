require "rails_helper"

RSpec.describe ContactFormsController, type: :controller do
  describe "GET #new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    let(:valid_attributes) { {name: "John Doe", email: "john@example.com", message: "Test message"} }
    let(:invalid_attributes) { {name: "", email: "", message: ""} }
    let(:recaptcha_token) { "valid_recaptcha_token" }
    let(:recaptcha_response) do
      {
        "success" => true,
        "score" => 0.9
      }
    end

    before do
      # reCAPTCHAリクエストのスタブ
      stub_request(:post, "https://www.google.com/recaptcha/api/siteverify")
        .to_return(
          body: recaptcha_response.to_json,
          headers: {"Content-Type" => "application/json"}
        )
    end

    context "with valid attributes and valid reCAPTCHA" do
      it "creates a new contact form and sends emails" do
        expect do
          post :create, params: {contact_form: valid_attributes.merge(recaptcha_token: recaptcha_token)}
        end.to change(ContactForm, :count).by(1)

        expect(response).to redirect_to("/")
        expect(flash[:notice]).to eq("お問い合わせを受け付けました")
      end
    end

    context "with invalid attributes" do
      it "does not create a contact form and re-renders the new template" do
        expect do
          post :create, params: {contact_form: invalid_attributes.merge(recaptcha_token: recaptcha_token)}
        end.not_to change(ContactForm, :count)

        expect(response).to render_template(:new)
      end
    end

    context "with invalid reCAPTCHA" do
      let(:recaptcha_response) { {"success" => false, "score" => 0.3} }

      it "does not create a contact form and re-renders the new template with an error" do
        expect do
          post :create, params: {contact_form: valid_attributes.merge(recaptcha_token: recaptcha_token)}
        end.not_to change(ContactForm, :count)

        expect(response).to render_template(:new)
        expect(flash[:alert]).to eq("reCAPTCHA認証に失敗しました。もう一度お試しください。")
      end
    end

    context "when email sending fails" do
      before do
        allow(ContactFormMailer).to receive(:send_mail).and_raise(StandardError, "Mail sending failed")
      end

      it "logs an error and re-renders the new template" do
        expect(Rails.logger).to receive(:error).with(/メール送信後のエラー/)

        post :create, params: {contact_form: valid_attributes.merge(recaptcha_token: recaptcha_token)}

        expect(response).to render_template(:new)
        expect(flash[:alert]).to eq("エラーが発生しました。管理者に連絡してください。")
      end
    end
  end
end
