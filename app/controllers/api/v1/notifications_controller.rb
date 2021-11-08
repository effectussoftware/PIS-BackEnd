module Api
  module V1
    class NotificationsController < Api::V1::ApiController
      def index
        uid = request.headers[:uid]

        @notifications = User.find_by(email: uid).obtain_notifications
        render :index
      end

      def update
        id = params_alerts[:id]
        alert_type = params_alerts[:alert_type]
        user = User.find_by(email: request.headers[:uid])
        @notifications = user.update_notification(id, alert_type)
        render json: { message: I18n.t('api.success.alerts.record_update') }
      rescue ActiveRecord::RecordNotFound
        render json: { error: I18n.t('api.errors.not_found') }
      end

      private

      def params_alerts
        permitted = params.permit(:alert_type, :id)
        alert_type = permitted[:alert_type]

        unless alert_type.blank? || alert_type.in?(%w[project person])
          raise ActiveRecord::RecordInvalid(I18n.t('errors.messages.invalid_param',
                                                   { param: params_alerts[:alert_type] }))
        end
        permitted
      end
    end
  end
end
