module Api
  module V1
    class NotificationsController < Api::V1::ApiController

      def index
        uid = params_notifications[:uid]
        user = User.find_by(email: uid)
        @notifications = user.get_notifications
        render :index
      end

      def update
        uid = params_notifications[:uid]
        id = params_notifications[:id]
        alert_type = params_notifications[:alert_type]
        user = User.find_by(email: uid)
        @notifications = user.update_notification(id,alert_type)
      end

      def params_notifications
        params.require(:uid)
      end
    end
  end
end
