module Api
  module V1
    class ProjectsController < Api::V1::ApiController
      def create
        @project = Project.create!(project_params)
        @project.add_project_technologies(technologies_params)
        render :show
      end

      def index
        @projects = Project.includes(:people, :person_project).all
      end

      def show
        @project = Project.includes(:people, :person_project).find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: I18n.t('api.errors.project.not_found') }, status: :not_found
      end

      def update
        @project = Project.find(params[:id])
        # -> ProjectObserver.before_update(params[:id],params[:end_date])
        @project.update!(project_params)
        @project.rebuild_project_technologies(technologies_params)
        render :show
      rescue ActiveRecord::RecordNotFound
        render json: { error: I18n.t('api.errors.project.not_found') }, status: :not_found
      end

      def destroy
        destroy_alerts_from_project
        project = Project.find(params[:id])
        project.destroy!

        render json: { message: I18n.t('api.success.project.record_delete',
        { name: project.name }) }
      rescue ActiveRecord::RecordNotFound
        render json: { error: I18n.t('api.errors.project.not_found') }, status: :not_found
      end

      private

      def destroy_alerts_from_project
        UserProject.where(project_id: params[:id]).delete_all
      end

      def project_params
        params.require(:project).permit(:name, :description, :start_date,
                                        :project_type, :project_state, :budget, :end_date,
                                        :organization)
      end

      def technologies_params
        params.require(:project)
        params[:project][:technologies]
      end
    end
  end
end
