class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[show index]

  # GET /posts or /posts.json
  def index
    @posts = Post.all.order(created_at: :desc)
    @show_full_content = false
  end

  # GET /posts/1 or /posts/1.json
  def show
    # @post.views += 1
    # @post.save
    @post.update(views: @post.views + 1)
    @comments = @post.comments.order(created_at: :desc)

    @show_full_content = true

    mark_notification_as_read
  end

  # GET /posts/new
  def new
  @post = Post.new
  respond_to do |format|
    format.html { render :new }
    format.turbo_stream { render :new } # Turboフレームでリクエストされた場合
  end
end
  # GET /posts/1/edit
  def edit
    respond_to do |format|
    format.html { render :new }
    format.turbo_stream { render :new } # Turboフレームでリクエストされた場合
  end
  end

  # POST /posts or /posts.json
  def create
  @post = Post.new(post_params)
  @post.user = current_user

  if @post.save
    flash.now[:notice] = "投稿が成功しました"
    render turbo_stream: [
      turbo_stream.prepend("posts", partial: "post", locals: { post: @post }),
      turbo_stream.replace("modal", ""), # 成功時にモーダルを閉じる
      turbo_stream.update("flash", partial: "layouts/flash") # フラッシュメッセージを表示
    ]
  else
    render turbo_stream: turbo_stream.replace("modal", partial: "posts/error", locals: { post: @post }), status: :unprocessable_entity
  end
end


  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html do
          redirect_to post_url(@post), notice: "Post was successfully updated."
        end
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html do
        redirect_to posts_url, notice: "Post was successfully destroyed."
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :body, :name, :category_id)
  end

  def mark_notification_as_read
    if current_user
      notifications_to_mark_as_read =
        @post.notifications_as_post.where(recipient: current_user)
      notifications_to_mark_as_read.update_all(read_at: Time.zone.now)
    end
  end
end
