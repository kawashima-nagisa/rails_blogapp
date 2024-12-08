require "rails_helper"

RSpec.describe PagesController, type: :controller do
  describe "GET #home" do
    it "renders the home template" do
      get :home
      expect(response).to render_template(:home)
    end
  end

  describe "GET #about" do
    let(:user_id) { "nagisa-afadfadf" }
    let(:qiita_response) do
      [
        {
          "title" => "First Article",
          "url" => "https://qiita.com/example/items/1"
        },
        {
          "title" => "Second Article",
          "url" => "https://qiita.com/example/items/2"
        }
      ]
    end

    before do
      # Qiita APIリクエストのスタブ
      stub_request(:get, "https://qiita.com/api/v2/users/#{user_id}/items")
        .with(
          headers: {
            "Authorization" => "Bearer #{Rails.application.credentials.dig(:qiita, :access_token)}"
          }
        )
        .to_return(
          status: 200,
          body: qiita_response.to_json,
          headers: {"Content-Type" => "application/json"}
        )
    end

    it "assigns @articles with Qiita articles" do
      get :about
      expect(assigns(:articles)).to eq(qiita_response)
    end

    it "renders the about template" do
      get :about
      expect(response).to render_template(:about)
    end

    context "when Qiita API returns an error" do
      before do
        stub_request(:get, "https://qiita.com/api/v2/users/#{user_id}/items")
          .to_return(status: 404, body: "", headers: {})
      end

      it "assigns @articles as nil when API fails" do
        get :about
        expect(assigns(:articles)).to be_nil
      end
    end
  end
end
