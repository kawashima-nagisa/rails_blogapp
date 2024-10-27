class ApplicationController < ActionController::Base
  before_action :set_notifications, if: :current_user
  before_action :set_query

  def set_query
    @q = Post.ransack(params[:q])
  end

  def destroy_notification
    @notification = current_user.notifications.find(params[:id])
    @notification.destroy
    respond_to do |format|
      format.html do
        redirect_back fallback_location: root_path, notice: "通知が削除されました。"
      end
      format.json { head :no_content }
      format.turbo_stream do
        render turbo_stream:
                 turbo_stream.remove("notification-#{@notification.id}")
      end
    end
  end

  private

  def set_notifications
    notifications =
      Notification
        .includes(:recipient)
        .where(recipient: current_user)
        .newest_first
        .limit(9)
    @unread = notifications.unread
    @read = notifications.read
  end
end
