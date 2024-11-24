class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show edit update destroy]
  before_action :authenticate_user!

  # GET /categories or /categories.json
  def index
    @categories = Category.all
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash.now[:notice] = "投稿が成功しました"
      render turbo_stream: [
        turbo_stream.prepend(
          "categories", # `categories`というIDを持つ要素に追加することを想定
          partial: "categories/category",
          locals: {
            category: @category
          }
        ),
        turbo_stream.replace("modal", ""), # 成功時にモーダルを閉じる
        turbo_stream.update("flash", partial: "layouts/flash") # フラッシュメッセージを表示

      ]
    else
      render turbo_stream:
               turbo_stream.replace(
                 "modal",
                 partial: "posts/error",
                 locals: {
                   category: @category
                 }
               ),
        status: :unprocessable_entity
    end
  end


  def update
    if @category.update(category_params)
      flash.now[:notice] = "更新が成功しました"
      render turbo_stream: [
        turbo_stream.replace(
          "category_#{@category.id}",
          partial: "categories/category",
          locals: {
            category: @category
          }
        ),
        turbo_stream.replace("modal", ""), # 成功時にモーダルを閉じる
        turbo_stream.update("flash", partial: "layouts/flash") # フラッシュメッセージを表示
      ]
    else
      render turbo_stream:
               turbo_stream.replace(
                 "modal",
                 partial: "posts/error",
                 locals: {
                   category: @category
                 }
               ),
        status: :unprocessable_entity
    end
  end

  # # PATCH/PUT /categories/1 or /categories/1.json
  # def update
  #   respond_to do |format|
  #     if @category.update(category_params)
  #       format.html do
  #         redirect_to category_url(@category),
  #           notice: "カテゴリーの更新をしました。"
  #       end
  #       format.json { render :show, status: :ok, location: @category }
  #     else
  #       format.html { render :edit, status: :unprocessable_entity }
  #       format.json do
  #         render json: @category.errors, status: :unprocessable_entity
  #       end
  #     end
  #   end
  # end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    @category.destroy!

    respond_to do |format|
      format.html do
        redirect_to categories_url,
          notice: "カテゴリーの削除をしました。"
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def category_params
    params.require(:category).permit(:name)
  end
end
