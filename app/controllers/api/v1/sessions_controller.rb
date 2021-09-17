module Api
  module V1
    class SessionsController < DeviseTokenAuth::SessionsController
      protect_from_forgery with: :null_session
      before_action :update_auth_header, only: :send_reset_password

      include Api::Concerns::ActAsApiRequest

      def create
        super do |resource|
          return send_reset_password if resource.needs_password_reset?
        end
      end

      private

      def resource_params
        params.require(:user).permit(:email, :password)
      end

      def render_create_success
        render :create
      end

      def send_reset_password
        render json: { needs_password_reset: true,
                       error: I18n.t('api.errors.needs_password_reset') },
               status: :unauthorized
      end
    end
  end
end
