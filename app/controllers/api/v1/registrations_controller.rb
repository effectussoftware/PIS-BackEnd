module Api
  module V1
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      # protect_from_forgery with: :exception
      skip_forgery_protection
      include Api::Concerns::ActAsApiRequest

      private

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation,
                                     :first_name, :last_name)
      end

      def render_create_success
        user = User.find_by(email: sign_up_params[:email])
        Project.all.each { |proyect| proyect.add_alert(user) }

        render :create
      end
    end
  end
end
