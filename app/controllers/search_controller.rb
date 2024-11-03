class SearchController < ApplicationController
  protect_from_forgery except: :autocomplete
  def index
    @q = Post.joins(:user).ransack(params[:q])

    @posts = (params[:q].present? ? @q.result(distinct: true) : Post.all)
  end

  def autocomplete
    query = "%#{params[:q]}%"

    # Post を基点に、タイトル、本文、ユーザー名、カテゴリー名を含む投稿を検索
    @posts =
      Post
        .left_outer_joins(:user, :category)
        .where(
          "posts.title LIKE :query OR posts.body LIKE :query OR users.name LIKE :query OR categories.name LIKE :query",
          query: query
        )
        .limit(10)

    respond_to do |format|
      format.js { render partial: "search/autocomplete_results" }
    end
  end
end
