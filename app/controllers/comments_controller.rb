class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @comment = @post.comments.create(comment_params)
    @comment.user = current_user

    if @comment.save
      flash[:notice] = "コメントを作成しました。"
      redirect_to post_path(@post)
    else
      flash[:alert] = "コメントの作成に失敗しました。"
      redirect_to post_path(@post)
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])

    @comment.destroy
    redirect_to post_path(@post)
  end

  def update
    @comment = @post.comments.find(params[:id])

    # @comment.update(comment_params)
    #   redirect_to  post_path(@post)

    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to post_url(@post), notice: "コメントが更新されました" }
        format.json { render json: @comment, status: :ok }
      else
        format.html { redirect_to post_url(@post), alert: "コメントが更新されませんでした" }
        format.json do
          render json: @comment.errors, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
