module Api
  module V1
    class PersonProjectController < Api::V1::ApiController
      include Filterable
      def create
        @person_project = Person.find(params[:person_id])
                                .person_project.create!(person_project_params)
        render :show
      end

      def index
        projects = filter!(Project).select('projects.id as project_id')
        @people = Person.joins(:projects, "INNER JOIN (#{projects.to_sql}) AS project_filter" \
          ' ON projects.id = project_filter.project_id')
                        .includes(:person_project, :projects)
                        .references(:project).uniq
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
        person_project = PersonProject.find(params[:id]).destroy!
        render json: { message: I18n.t('api.success.person_project.record_delete',
                                       { role: person_project.role,
                                         person_name: person_project.person_first_name,
                                         project_name: person_project.project_name }) }
      rescue ActiveRecord::RecordNotFound
        render json: { error: I18n.t('api.errors.person_project.not_found') }, status: :not_found
      end

      private

      def person_project_params
        params.require(:person_project).permit(:project_id, :role, :working_hours,
                                               :working_hours_type, :start_date, :end_date)
      end

      def update_person_project_params
        params.require(:person_project).permit(:role, :working_hours,
                                               :working_hours_type, :start_date, :end_date)
      end
    end
  end
end
