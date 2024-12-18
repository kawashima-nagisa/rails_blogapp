require "rails_helper"

RSpec.describe Users::RegistrationsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  let(:valid_user_params) { {email: "test@example.com", password: "password", name: "Test User"} }

  describe "POST #create" do
    context "reCAPTCHAの検証が成功した場合" do
      before do
        allow(controller).to receive(:verify_recaptcha).and_return(true)
      end

      it "新規登録が成功し、ユーザーが作成される" do
        expect {
          post :create, params: {user: valid_user_params}
        }.to change(User, :count).by(1)

        expect(response).to redirect_to(posts_path)
      end
    end

    context "reCAPTCHAの検証が失敗した場合" do
      before do
        allow(controller).to receive(:verify_recaptcha).and_return(false)
      end

      it "新規登録が失敗し、エラーメッセージが表示される" do
        expect {
          post :create, params: {user: valid_user_params}
        }.not_to change(User, :count)

        expect(response).to redirect_to(new_user_registration_path)
        expect(flash[:alert]).to eq("reCAPTCHA認証に失敗しました。もう一度お試しください。")
      end
    end
  end

  describe "PATCH #update" do
    let(:user) { create(:user) }
    let(:update_params) { {name: "Updated Name"} }

    before do
      sign_in user
    end

    it "ユーザー情報が更新される" do
      patch :update, params: {user: update_params}
      user.reload

      expect(user.name).to eq("Updated Name")
      expect(response).to redirect_to(root_path)
    end
  end

  describe "#after_sign_in_path_for" do
    let(:user) { create(:user) }

    it "ログイン後にposts_pathにリダイレクトすること" do
      # サインインしてリダイレクト先を確認
      sign_in user
      expect(controller.after_sign_in_path_for(user)).to eq(posts_path)
    end
  end
end
