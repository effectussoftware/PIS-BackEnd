module Api
  module V1
    class PeopleController < Api::V1::ApiController
      def create
        @person = Person.create!(person_params)
      end

      def index
        @people = Person.all
        # Render persons list
      end

      def show
        # show
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
