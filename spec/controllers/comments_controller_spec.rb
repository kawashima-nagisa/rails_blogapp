require "rails_helper"

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:post_record) { create(:post, user: user) }
  let(:comment) { create(:comment, post: post_record, user: user) }

  before do
    sign_in user # Deviseを利用して認証済みユーザーに設定
  end

  describe "POST #create" do
    it "creates a new comment" do
      expect {
        post :create, params: {post_id: post_record.id, comment: {body: "New comment"}}
      }.to change(Comment, :count).by(1)
      expect(response).to redirect_to(post_path(post_record))
      expect(flash[:notice]).to eq("コメントを作成しました。")
    end

    it "does not create a new comment with invalid data" do
      expect {
        post :create, params: {post_id: post_record.id, comment: {body: ""}}
      }.not_to change(Comment, :count)
      expect(response).to redirect_to(post_path(post_record))
      expect(flash[:alert]).to eq("コメントの作成に失敗しました。")
    end
  end

  describe "DELETE #destroy" do
    it "deletes the comment" do
      comment # コメントを事前に作成
      expect {
        delete :destroy, params: {post_id: post_record.id, id: comment.id}
      }.to change(Comment, :count).by(-1)
      expect(response).to redirect_to(post_path(post_record))
    end
  end
end
