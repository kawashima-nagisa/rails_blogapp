class SearchController < ApplicationController
  def index
    @q = Post.joins(:user).ransack(params[:q])

    if params[:q].present?
      @posts = @q.result(distinct: true)
    else
      @posts = Post.all
    end
  end
end
