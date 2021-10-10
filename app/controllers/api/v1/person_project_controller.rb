module Api
  module V1
    class PersonProjectController < Api::V1::ApiController
      def create
        @person_project = Person.find(params[:person_id])
                                .person_project.create!(person_project_params)
        render :show
      end

      def index
        # FIXME: Arreglar 'eager loading detected' para person_project
        @people = Person.includes(:projects).references(:projects).group('projects.id', 'people.id')
      end

      def show
        @person_project = PersonProject.includes(:person, :project).find(params[:id])
      end

      def update
        @person_project = PersonProject.includes(:person, :project).find(params[:id])
        @person_project.update!(update_person_project_params)
        render :show
      rescue ActiveRecord::RecordNotFound
        render json: { error: I18n.t('api.errors.person_project.not_found') }, status: :not_found
      end

      def destroy
        person_project = PersonProject.find(params[:id])
        person_project.destroy!
        render json: { message: I18n.t('api.success.person_project.record_delete',
                                       { rol: person_project.rol,
                                         person_name: person_project.person.first_name,
                                         project_name: person_project.project.name }) }
      rescue ActiveRecord::RecordNotFound
        render json: { error: I18n.t('api.errors.person_project.not_found') }, status: :not_found
      end

      private

      def person_project_params
        params.require(:person_project).permit(:project_id, :rol, :working_hours,
                                               :working_hours_type, :start_date, :end_date)
      end

      def update_person_project_params
        params.require(:person_project).permit(:rol, :working_hours,
                                               :working_hours_type, :start_date, :end_date)
      end
    end
  end
end
