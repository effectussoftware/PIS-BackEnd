module Api
  module V1
    class PeopleController < Api::V1::ApiController
      def create
        @person = Person.create!(person_params)
        render :show
      end

      def index
        @people = Person.all
        # Render persons list
      end

      def show
        @person = Person.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: I18n.t('api.errors.person.not_found') }, status: :not_found
      end

      def update
        # update
      end

      def destroy
        # destroy
      end

      private

      def person_params
        params.require(:person).permit(:first_name, :last_name, :email, :hourly_load,
                                       :hourly_load_hours)
      end
    end
  end
end
