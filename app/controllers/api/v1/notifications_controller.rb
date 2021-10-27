module Api
  module V1
    class NotificationsController < Api::V1::ApiController
      def index
        uid = request.headers[:uid]
        user = User.find_by(email: uid)
        @notifications = user.obtain_notifications
        render :index
      end

      def update
        id = params_alerts[:id]
        alert_type = params_alerts[:alert_type]

        user = User.find_by(email: request.headers[:uid])
        @notifications = user.update_notification(id, alert_type)

        render :index
      end

      private

      def params_alerts
        params.permit(:alert_type, :id)
      end
    end
  end
end
