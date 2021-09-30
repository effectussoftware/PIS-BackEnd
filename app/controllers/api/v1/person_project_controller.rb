module Api
  module V1
    class PersonProjectController < Api::V1::ApiController
      def create
        @person_project = Person.find(params[:person_id]).person_project.create!(person_project_params)
        render :show
      end

      def index
        @person = Person.find(params[:person_id])
      end

      def person_project_params
        params.require(:person_project).permit(:project_id, :rol, :working_hours,
                                               :working_hours_type, :start_date, :end_date)
      end
    end
  end
end
