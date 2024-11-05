class UsersController < ApplicationController
  before_action :set_user

  def profile
    @user = User.find(params[:id])
    @user.update(views: @user.views + 1)

    # created_at と updated_at の両方で日別の投稿数を集計
    created_posts = @user.posts.group("DATE(created_at)").count
    updated_posts = @user.posts.group("DATE(updated_at)").count

    # created_at と updated_at の集計結果を合わせる
    @daily_counts =
      created_posts.merge(updated_posts) do |_, created, updated|
        created + updated
      end

    # JSON形式に変換してJavaScriptで利用可能にする
    @chart_data =
      @daily_counts.map do |date, count|
        {
          x: Date.parse(date.to_s).to_time.to_i * 1000, # タイムスタンプに変換
          y: Date.parse(date.to_s).wday, # 曜日を数値で取得 (0=日曜, 6=土曜)
          v: count
        }
      end
  end

  def update
    if @user.update(user_params)
      puts "画像が添付されましたか？: #{@user.profile_image.attached?}"
      redirect_to user_path(@user), notice: "プロフィール画像が更新されました。"
    else
      render :profile
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:profile_image) # profile_imageを許可
  end
end
