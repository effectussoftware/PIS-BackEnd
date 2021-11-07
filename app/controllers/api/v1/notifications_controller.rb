module Api
  module V1
    class NotificationsController < Api::V1::ApiController
      def index
        uid = request.headers[:uid]
        # byebug
        # User.find(uid).obtain_notifications
        # user = User.includes(:user_projects, :user_people).find_by(email: uid)
                 # .includes(:user_projects, :user_people, user_projects: :project, user_people: :person)
                 #   .references(user_projects: :project, user_people: :person)


        @notifications = User#.includes(:user_projects, :user_people)
                             .includes(:user_projects)
                             .find_by(email: uid).obtain_notifications

        render :index
      end

      def update
        id = params_alerts[:id]
        alert_type = params_alerts[:alert_type]

        user = User.find_by(email: request.headers[:uid])
        @notifications = user.update_notification(id, alert_type)
        render json: { message: 'Alerta modificada con exito.' }
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Error, alerta no encontrada.' }
      end

      private

      def params_alerts
        params.permit(:alert_type, :id)
      end
    end
  end
end
