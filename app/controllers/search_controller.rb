class SearchController < ApplicationController
  def index
    @q = Post.joins(:user).ransack(params[:q])

    @posts = if params[:q].present?
      @q.result(distinct: true)
    else
      Post.all
    end
  end
end
