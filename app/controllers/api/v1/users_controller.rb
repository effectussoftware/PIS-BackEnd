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

      def destroy
        user = User.find(params[:id])
        name = user.first_name + ' ' + user.last_name
        user.destroy!
        render json: { message: I18n.t('api.success.user.record_delete',
                                       { name: name }) }
      rescue ActiveRecord::RecordNotFound
        render json: { error: I18n.t('api.errors.user.not_found') }, status: :not_found
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
