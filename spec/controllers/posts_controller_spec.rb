require "rails_helper"

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:post) { create(:post, user: user, category: category) }

  before { sign_in user }

  describe "GET #index" do
    it "すべての投稿が表示される" do
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:posts)).to include(post)
      expect(assigns(:show_full_content)).to be(false)
    end

    it "カテゴリフィルタが機能する" do
      get :index, params: {category_id: category.id}
      expect(assigns(:category)).to eq(category)
      expect(assigns(:posts)).to all(have_attributes(category_id: category.id))
    end
  end

  describe "GET #show" do
    it "投稿が表示され、ビュー数が増加する" do
      expect { get :show, params: {id: post.id} }.to change { post.reload.views }.by(1)
      expect(response).to have_http_status(:success)
      expect(assigns(:comments)).to eq(post.comments.order(created_at: :desc))
      expect(assigns(:show_full_content)).to be(true)
    end
  end

  describe "PATCH #update" do
    context "有効なデータの場合" do
      it "投稿が更新され、turbo_streamでフラッシュメッセージが表示される" do
        patch :update, params: {id: post.id, post: {title: "新しいタイトル"}}, format: :turbo_stream
        expect(post.reload.title).to eq("新しいタイトル")
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end

    context "無効なデータの場合" do
      it "更新に失敗し、エラーメッセージが表示される" do
        patch :update, params: {id: post.id, post: {title: ""}}, format: :turbo_stream
        expect(response).to have_http_status(:unprocessable_entity)
        expect(post.reload.title).not_to eq("")
      end
    end
  end

  describe "DELETE #destroy" do
    it "投稿が削除され、投稿一覧にリダイレクトされる" do
      post # 投稿を作成
      expect {
        delete :destroy, params: {id: post.id}
      }.to change(Post, :count).by(-1)
      expect(response).to redirect_to(posts_path)
    end
  end
end
