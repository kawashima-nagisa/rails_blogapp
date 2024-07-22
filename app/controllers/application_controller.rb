class ApplicationController < ActionController::Base
   before_action :set_notifications, if: :current_user


   def destroy_notification
    @notification = current_user.notifications.find(params[:id])
    @notification.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: '通知が削除されました。' }
      format.json { head :no_content }
      format.turbo_stream { render turbo_stream: turbo_stream.remove("notification-#{@notification.id}") }
    end
  end


  private
  
   def set_notifications
    notifications = Notification.includes(:recipient).where(recipient: current_user).newest_first.limit(9)
    @unread = notifications.unread
    @read = notifications.read
  end
end
