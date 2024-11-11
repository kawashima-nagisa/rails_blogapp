require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:user) { create(:user) }
  let(:category) { create(:category) }

  before { sign_in user }

  describe 'GET #index' do
    it 'すべてのカテゴリが表示される' do
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:categories)).to include(category)
    end
  end

  describe 'GET #new' do
    it '新しいカテゴリ作成ページが表示される' do
      get :new
      expect(response).to have_http_status(:success)
      expect(assigns(:category)).to be_a_new(Category)
    end
  end

  describe 'GET #edit' do
    it 'カテゴリ編集ページが表示される' do
      get :edit, params: { id: category.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:category)).to eq(category)
    end
  end

  describe 'POST #create' do
    context '有効なデータの場合' do
      it '新しいカテゴリが作成され、リダイレクトされる' do
        category_params = attributes_for(:category)

        expect {
          post :create, params: { category: category_params }
        }.to change(Category, :count).by(1)

        expect(response).to redirect_to(category_path(assigns(:category)))
        expect(flash[:notice]).to eq("Category was successfully created.")
      end
    end
  end

  describe 'PATCH #update' do
    context '有効なデータの場合' do
      it 'カテゴリが更新され、リダイレクトされる' do
        patch :update, params: { id: category.id, category: { name: "新しいカテゴリ名" } }
        expect(response).to redirect_to(category_path(category))
        expect(flash[:notice]).to eq("Category was successfully updated.")
        expect(category.reload.name).to eq("新しいカテゴリ名")
      end
    end

    
  end

  describe 'DELETE #destroy' do
    it 'カテゴリが削除され、カテゴリ一覧にリダイレクトされる' do
      category # 作成しておく
      expect {
        delete :destroy, params: { id: category.id }
      }.to change(Category, :count).by(-1)

      expect(response).to redirect_to(categories_path)
      expect(flash[:notice]).to eq("Category was successfully destroyed.")
    end
  end
end
