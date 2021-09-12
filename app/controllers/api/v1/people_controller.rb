module Api
  module V1
    class PeopleController < Api::V1::ApiController
      def index
        # Render persons list
      end

      def show; end

      def update; end

      def destroy; end

      private

      def person_params
        params.require(:person).permit(:first_name, :last_name, :email, :hourly_load,
                                       :hourly_load_hours)
      end
    end
  end
end
