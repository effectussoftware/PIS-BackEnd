module Api
  module V1
    class PersonProjectController < Api::V1::ApiController
      def create
        @person_project = Person.find(params[:person_id]).person_project.create!(person_project_params)
        # render :show
        render json: {}
        # create
      end

      def index
        # index
      end

      def person_project_params
        params.require(:person_project).permit(:project_id, :rol, :working_hours,
                                               :working_hours_type, :start_date, :end_date)
      end
    end
  end
end
