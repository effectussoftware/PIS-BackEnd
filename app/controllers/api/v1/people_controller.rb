module Api
  module V1
    class PeopleController < Api::V1::ApiController
      def create

        @person = Person.create!(person_params)
        add_person_technologies(@person,params[:technologies])
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
        add_person_technologies(@person,params[:technologies])
        @person = @person.update(person_params)
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

      def add_person_technologies(person,technologies)
        return person if technologies.blank? || technologies.kind_of?(Array)
        technologies.each do |tech| # tech = [nombre_tecnologia, seniority]
          technology = Technology.find_or_create_single(tech[0])
          person.add_technology(technology, tech[1])
        end
      end

      def person_params
        params.require(:person).permit(:first_name, :last_name, :email,
                                       :working_hours, :technologies)
=begin
        person: {
          ...
            "technologies":[
                            {"technology":"Java", "seniority":"senior"},
                            {"technology":"ruby", "seniority":"junior"}
            ]
          ...
        }
=end
      end
    end
  end
end
