module Api
  module V1
    class UsersController < Api::V1::ApiController
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
        if current_user?(user)
          render json: { message: I18n.t('api.errors.user.invalid_delete') }
        else
          full_name = user.full_name
          user.destroy!
          render json: { message: I18n.t('api.success.user.record_delete',
                                         { name: full_name }) }
        end
      end

      private

      def current_user?(user)
        current_user.id == user.id
      end

      def user_params
        params.require(:user).permit(:first_name, :last_name, :email)
      end
    end
  end
end
