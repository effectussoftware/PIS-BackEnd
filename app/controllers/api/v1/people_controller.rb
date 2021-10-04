module Api
  module V1
    class PeopleController < Api::V1::ApiController
      def create
        @person = Person.create(person_params)
        @person.add_person_technologies(technologies_params)
        render :show
      end

      def index
        @people = Person.all
      end

      def show
        @person = Person.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: I18n.t('api.errors.person.not_found') }, status: :not_found
      end

      def update
        @person = Person.find(params[:id])
        @person.update(person_params)
        @person.add_person_technologies(technologies_params)
        render :show
      rescue ActiveRecord::RecordNotFound
        render json: { error: I18n.t('api.errors.person.not_found') }, status: :not_found
      end

      def destroy
        user = Person.find(params[:id])
        user.destroy!
        render json: { message: I18n.t('api.success.record_delete', { name: user.first_name }) }
      rescue ActiveRecord::RecordNotFound
        render json: { error: I18n.t('api.errors.person.not_found') }, status: :not_found
      end

      private

      def person_params
        params.require(:person).permit(:first_name, :last_name, :email,
                                       :working_hours)
      end
      def technologies_params
        params.require(:person)[:technologies]
      end
=begin
        person: {
          ...
            "technologies":[
                            [Java", "senior"],
                            ["ruby", "junior"]
            ]
          ...
        }
=end
    end
  end
end
