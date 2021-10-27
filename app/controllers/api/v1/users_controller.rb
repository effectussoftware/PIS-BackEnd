module Api
  module V1
    class UsersController < Api::V1::ApiController
      before_action :auth_user, except: :index

      def show; end

      def update
        current_user.update!(user_params)
        render :show
      end

      def index
        @admins = User.all
        render :index
      end

      private

      def auth_user
        authorize current_user
      end

      def user_params
        params.require(:user).permit(:first_name, :last_name, :email)
      end
    end
  end
end
